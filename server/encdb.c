#include "postgres.h"
#include "fmgr.h"

PG_MODULE_MAGIC;

PG_FUNCTION_INFO_V1(add_one);

Datum
add_one(PG_FUNCTION_ARGS)
{
    int32 arg = PG_GETARG_INT32(0);
    PG_RETURN_INT32(arg + 1);
}

/*
 * ORE compare cho ciphertext kiểu BIGINT
 * Giả định ciphertext là int8 (vd: plaintext + secret_offset).
 * Trả về:
 *   -1 nếu left < right
 *    0 nếu left = right
 *    1 nếu left > right
 */

PG_FUNCTION_INFO_V1(ore_cmp_int8);

Datum
ore_cmp_int8(PG_FUNCTION_ARGS)
{
    int64 left  = PG_GETARG_INT64(0);
    int64 right = PG_GETARG_INT64(1);

    if (left < right)
        PG_RETURN_INT32(-1);
    else if (left > right)
        PG_RETURN_INT32(1);
    else
        PG_RETURN_INT32(0);
}