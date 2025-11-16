-- Hàm C đơn giản để test extension
CREATE FUNCTION add_one(integer)
RETURNS integer
AS 'MODULE_PATHNAME', 'add_one'
LANGUAGE C STRICT IMMUTABLE;

-- 1) Hàm udf_aes_eq: so sánh 2 ciphertext AES bằng bytea =
CREATE FUNCTION udf_aes_eq(bytea, bytea)
RETURNS boolean
LANGUAGE SQL
IMMUTABLE STRICT
AS $$ SELECT $1 = $2 $$;


-- 2) DOMAIN cho ORE ciphertext
CREATE DOMAIN ore_en AS bigint;

-- 3) Overload udf_ore_cmp cho ore_en
CREATE FUNCTION udf_ore_cmp(bigint, bigint)
RETURNS integer
AS 'MODULE_PATHNAME', 'ore_cmp_int8'
LANGUAGE C STRICT IMMUTABLE;
-- Overload
CREATE FUNCTION udf_ore_cmp(ore_en, ore_en)
RETURNS integer
AS 'MODULE_PATHNAME', 'ore_cmp_int8'
LANGUAGE C STRICT IMMUTABLE;

-- 4) Wrapper functions cho so sánh ore_en
CREATE FUNCTION udf_ore_lt(ore_en, ore_en)
RETURNS boolean
LANGUAGE SQL IMMUTABLE STRICT
AS $$ SELECT udf_ore_cmp($1, $2) < 0 $$;

CREATE FUNCTION udf_ore_le(ore_en, ore_en)
RETURNS boolean
LANGUAGE SQL IMMUTABLE STRICT
AS $$ SELECT udf_ore_cmp($1, $2) <= 0 $$;

CREATE FUNCTION udf_ore_gt(ore_en, ore_en)
RETURNS boolean
LANGUAGE SQL IMMUTABLE STRICT
AS $$ SELECT udf_ore_cmp($1, $2) > 0 $$;

CREATE FUNCTION udf_ore_ge(ore_en, ore_en)
RETURNS boolean
LANGUAGE SQL IMMUTABLE STRICT
AS $$ SELECT udf_ore_cmp($1, $2) >= 0 $$;

CREATE FUNCTION udf_ore_eq(ore_en, ore_en)
RETURNS boolean
LANGUAGE SQL IMMUTABLE STRICT
AS $$ SELECT udf_ore_cmp($1, $2) = 0 $$;

-- 5) Operators cho type ore_en
CREATE OPERATOR < (
    LEFTARG   = ore_en,
    RIGHTARG  = ore_en,
    PROCEDURE = udf_ore_lt,
    COMMUTATOR = '>',
    NEGATOR   = '>=',
    RESTRICT  = scalarltsel,
    JOIN      = scalarltjoinsel
);

CREATE OPERATOR <= (
    LEFTARG   = ore_en,
    RIGHTARG  = ore_en,
    PROCEDURE = udf_ore_le,
    COMMUTATOR = '>=',
    NEGATOR   = '>',
    RESTRICT  = scalarlesel,
    JOIN      = scalarlejoinsel
);

CREATE OPERATOR = (
    LEFTARG   = ore_en,
    RIGHTARG  = ore_en,
    PROCEDURE = udf_ore_eq,
    COMMUTATOR = '=',
    NEGATOR   = '<>',
    RESTRICT  = eqsel,
    JOIN      = eqjoinsel
);

CREATE OPERATOR >= (
    LEFTARG   = ore_en,
    RIGHTARG  = ore_en,
    PROCEDURE = udf_ore_ge,
    COMMUTATOR = '<=',
    NEGATOR   = '<',
    RESTRICT  = scalargesel,
    JOIN      = scalargejoinsel
);

CREATE OPERATOR > (
    LEFTARG   = ore_en,
    RIGHTARG  = ore_en,
    PROCEDURE = udf_ore_gt,
    COMMUTATOR = '<',
    NEGATOR   = '<=',
    RESTRICT  = scalargtsel,
    JOIN      = scalargtjoinsel
);

-- 6) B-Tree operator class cho ore_en (cipher index)
CREATE OPERATOR CLASS ore_en_ops
DEFAULT FOR TYPE ore_en USING btree AS
    OPERATOR 1 <  (ore_en, ore_en),
    OPERATOR 2 <= (ore_en, ore_en),
    OPERATOR 3 =  (ore_en, ore_en),
    OPERATOR 4 >= (ore_en, ore_en),
    OPERATOR 5 >  (ore_en, ore_en),
    FUNCTION 1 udf_ore_cmp(ore_en, ore_en);


-- UDF cộng 2 ciphertext AHE
CREATE FUNCTION udf_ahe_add(bigint, bigint)
RETURNS bigint
LANGUAGE SQL IMMUTABLE STRICT
AS $$ SELECT $1 + $2 $$;

-- Aggregate ahe_sum: dùng udf_ahe_add để tính tổng ciphertext
CREATE AGGREGATE ahe_sum(bigint) (
    SFUNC    = udf_ahe_add,
    STYPE    = bigint,
    INITCOND = '0'
);

-------------------------------------------------------------------------------
-- 5. MHE — Multiplicatively Homomorphic Encryption (toy)
--    Ciphertext: c = x_scaled * MHE_K
--    Server chỉ nhân ciphertext, không có key.
-------------------------------------------------------------------------------

-- UDF nhân 2 ciphertext MHE
CREATE FUNCTION udf_mhe_mul(bigint, bigint)
RETURNS bigint
LANGUAGE SQL IMMUTABLE STRICT
AS $$ SELECT $1 * $2 $$;

-- Aggregate mhe_prod: dùng udf_mhe_mul để tính tích ciphertext
CREATE AGGREGATE mhe_prod(bigint) (
    SFUNC    = udf_mhe_mul,
    STYPE    = bigint,
    INITCOND = '1'
);
