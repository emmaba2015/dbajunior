col name format a40;
SELECT NAME, space_limit / 1024 / 1024 mb_space_limit,
       space_used / 1024 / 1024 mb_space_used,
       space_reclaimable / 1024 / 1024 mb_space_reclaimable,
       (space_limit - space_used + space_reclaimable) / 1024 / 1024 fra_available_mb,
       (space_limit - space_used + space_reclaimable) / space_limit * 100 PERCENT
FROM v$recovery_file_dest;
