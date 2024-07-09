local metric(name) = {
  local eq(value) = {
    output(field): '%s%s"%s"' % [field, '=', value],
  },
  local labels = [[field, self[field]] for field in std.sort(std.objectFields(self)) if field != 'output'],
  local comparisons = [[label[0], if std.type(label[1]) == 'string' then eq(label[1]) else label[1]] for label in labels],
  local filters = [comparison[1].output(comparison[0]) for comparison in comparisons],
  local filterString = std.join(', ', filters),
  output: if (std.length(filterString) > 0) then '%s{%s}' % [name, filterString] else name,
};

local prometheus = {
  // HELP The current number of remote read queries being executed or waiting.
  // TYPE gauge
  api_remote_read_queries: metric('prometheus_api_remote_read_queries'),

  // HELP A metric with a constant '1' value labeled by version, revision, branch, goversion from which prometheus was built, and the goos and goarch for the build.
  // TYPE gauge
  build_info: metric('prometheus_build_info'),

  // HELP Timestamp of the last successful configuration reload.
  // TYPE gauge
  config_last_reload_success_timestamp_seconds: metric('prometheus_config_last_reload_success_timestamp_seconds'),

  // HELP Whether the last configuration reload attempt was successful.
  // TYPE gauge
  config_last_reload_successful: metric('prometheus_config_last_reload_successful'),

  // HELP The current number of queries being executed or waiting.
  // TYPE gauge
  engine_queries: metric('prometheus_engine_queries'),

  // HELP The max number of concurrent queries.
  // TYPE gauge
  engine_queries_concurrent_max: metric('prometheus_engine_queries_concurrent_max'),

  // HELP Query timings
  // TYPE summary
  engine_query_duration_seconds: metric('prometheus_engine_query_duration_seconds'),

  // HELP State of the query log.
  // TYPE gauge
  engine_query_log_enabled: metric('prometheus_engine_query_log_enabled'),

  // HELP The number of query log failures.
  // TYPE counter
  engine_query_log_failures_total: metric('prometheus_engine_query_log_failures_total'),

  // HELP The total number of samples loaded by all queries.
  // TYPE counter
  engine_query_samples_total: metric('prometheus_engine_query_samples_total'),

  // HELP Histogram of latencies for HTTP requests.
  // TYPE histogram
  http_request_duration_seconds: metric('prometheus_http_request_duration_seconds'),

  // HELP Counter of HTTP requests.
  // TYPE counter
  http_requests_total: metric('prometheus_http_requests_total'),

  // HELP Histogram of response size for HTTP requests.
  // TYPE histogram
  http_response_size_bytes: metric('prometheus_http_response_size_bytes'),

  // HELP The number of alertmanagers discovered and active.
  // TYPE gauge
  notifications_alertmanagers_discovered: metric('prometheus_notifications_alertmanagers_discovered'),

  // HELP Total number of alerts dropped due to errors when sending to Alertmanager.
  // TYPE counter
  notifications_dropped_total: metric('prometheus_notifications_dropped_total'),

  // HELP The capacity of the alert notifications queue.
  // TYPE gauge
  notifications_queue_capacity: metric('prometheus_notifications_queue_capacity'),

  // HELP The number of alert notifications in the queue.
  // TYPE gauge
  notifications_queue_length: metric('prometheus_notifications_queue_length'),

  // HELP Whether Prometheus startup was fully completed and the server is ready for normal operation.
  // TYPE gauge
  ready: metric('prometheus_ready'),

  // HELP Exemplars in to remote storage, compare to exemplars out for queue managers.
  // TYPE counter
  remote_storage_exemplars_in_total: metric('prometheus_remote_storage_exemplars_in_total'),

  // HELP HistogramSamples in to remote storage, compare to histograms out for queue managers.
  // TYPE counter
  remote_storage_histograms_in_total: metric('prometheus_remote_storage_histograms_in_total'),

  // HELP Samples in to remote storage, compare to samples out for queue managers.
  // TYPE counter
  remote_storage_samples_in_total: metric('prometheus_remote_storage_samples_in_total'),

  // HELP The number of times release has been called for strings that are not interned.
  // TYPE counter
  remote_storage_string_interner_zero_reference_releases_total: metric('prometheus_remote_storage_string_interner_zero_reference_releases_total'),

  // HELP The duration for a rule to execute.
  // TYPE summary
  rule_evaluation_duration_seconds: metric('prometheus_rule_evaluation_duration_seconds'),

  // HELP The duration of rule group evaluations.
  // TYPE summary
  rule_group_duration_seconds: metric('prometheus_rule_group_duration_seconds'),

  // HELP Number of cache hit during refresh.
  // TYPE counter
  sd_azure_cache_hit_total: metric('prometheus_sd_azure_cache_hit_total'),

  // HELP Number of Azure service discovery refresh failures.
  // TYPE counter
  sd_azure_failures_total: metric('prometheus_sd_azure_failures_total'),

  // HELP The duration of a Consul RPC call in seconds.
  // TYPE summary
  sd_consul_rpc_duration_seconds: metric('prometheus_sd_consul_rpc_duration_seconds'),

  // HELP The number of Consul RPC call failures.
  // TYPE counter
  sd_consul_rpc_failures_total: metric('prometheus_sd_consul_rpc_failures_total'),

  // HELP Current number of discovered targets.
  // TYPE gauge
  sd_discovered_targets: metric('prometheus_sd_discovered_targets'),

  // HELP The number of DNS-SD lookup failures.
  // TYPE counter
  sd_dns_lookup_failures_total: metric('prometheus_sd_dns_lookup_failures_total'),

  // HELP The number of DNS-SD lookups.
  // TYPE counter
  sd_dns_lookups_total: metric('prometheus_sd_dns_lookups_total'),

  // HELP Current number of service discovery configurations that failed to load.
  // TYPE gauge
  sd_failed_configs: metric('prometheus_sd_failed_configs'),

  // HELP The number of File-SD read errors.
  // TYPE counter
  sd_file_read_errors_total: metric('prometheus_sd_file_read_errors_total'),

  // HELP The duration of the File-SD scan in seconds.
  // TYPE summary
  sd_file_scan_duration_seconds: metric('prometheus_sd_file_scan_duration_seconds'),

  // HELP The number of File-SD errors caused by filesystem watch failures.
  // TYPE counter
  sd_file_watcher_errors_total: metric('prometheus_sd_file_watcher_errors_total'),

  // HELP Number of HTTP service discovery refresh failures.
  // TYPE counter
  sd_http_failures_total: metric('prometheus_sd_http_failures_total'),

  // HELP The number of Kubernetes events handled.
  // TYPE counter
  sd_kubernetes_events_total: metric('prometheus_sd_kubernetes_events_total'),

  // HELP The number of failed WATCH/LIST requests.
  // TYPE counter
  sd_kubernetes_failures_total: metric('prometheus_sd_kubernetes_failures_total'),

  // HELP The duration of a Kuma MADS fetch call.
  // TYPE summary
  sd_kuma_fetch_duration_seconds: metric('prometheus_sd_kuma_fetch_duration_seconds'),

  // HELP The number of Kuma MADS fetch call failures.
  // TYPE counter
  sd_kuma_fetch_failures_total: metric('prometheus_sd_kuma_fetch_failures_total'),

  // HELP The number of Kuma MADS fetch calls that result in no updates to the targets.
  // TYPE counter
  sd_kuma_fetch_skipped_updates_total: metric('prometheus_sd_kuma_fetch_skipped_updates_total'),

  // HELP Number of Linode service discovery refresh failures.
  // TYPE counter
  sd_linode_failures_total: metric('prometheus_sd_linode_failures_total'),

  // HELP Number of nomad service discovery refresh failures.
  // TYPE counter
  sd_nomad_failures_total: metric('prometheus_sd_nomad_failures_total'),

  // HELP Total number of update events received from the SD providers.
  // TYPE counter
  sd_received_updates_total: metric('prometheus_sd_received_updates_total'),

  // HELP Total number of update events that couldn't be sent immediately.
  // TYPE counter
  sd_updates_delayed_total: metric('prometheus_sd_updates_delayed_total'),

  // HELP Total number of update events sent to the SD consumers.
  // TYPE counter
  sd_updates_total: metric('prometheus_sd_updates_total'),

  // HELP Total number of times scrape pools hit the label limits, during sync or config reload.
  // TYPE counter
  target_scrape_pool_exceeded_label_limits_total: metric('prometheus_target_scrape_pool_exceeded_label_limits_total'),

  // HELP Total number of times scrape pools hit the target limit, during sync or config reload.
  // TYPE counter
  target_scrape_pool_exceeded_target_limit_total: metric('prometheus_target_scrape_pool_exceeded_target_limit_total'),

  // HELP Total number of failed scrape pool reloads.
  // TYPE counter
  target_scrape_pool_reloads_failed_total: metric('prometheus_target_scrape_pool_reloads_failed_total'),

  // HELP Total number of scrape pool reloads.
  // TYPE counter
  target_scrape_pool_reloads_total: metric('prometheus_target_scrape_pool_reloads_total'),

  // HELP Total number of scrape pool creations that failed.
  // TYPE counter
  target_scrape_pools_failed_total: metric('prometheus_target_scrape_pools_failed_total'),

  // HELP Total number of scrape pool creation attempts.
  // TYPE counter
  target_scrape_pools_total: metric('prometheus_target_scrape_pools_total'),

  // HELP How many times a scrape cache was flushed due to getting big while scrapes are failing.
  // TYPE counter
  target_scrapes_cache_flush_forced_total: metric('prometheus_target_scrapes_cache_flush_forced_total'),

  // HELP Total number of scrapes that hit the body size limit
  // TYPE counter
  target_scrapes_exceeded_body_size_limit_total: metric('prometheus_target_scrapes_exceeded_body_size_limit_total'),

  // HELP Total number of scrapes that hit the native histogram bucket limit and were rejected.
  // TYPE counter
  target_scrapes_exceeded_native_histogram_bucket_limit_total: metric('prometheus_target_scrapes_exceeded_native_histogram_bucket_limit_total'),

  // HELP Total number of scrapes that hit the sample limit and were rejected.
  // TYPE counter
  target_scrapes_exceeded_sample_limit_total: metric('prometheus_target_scrapes_exceeded_sample_limit_total'),

  // HELP Total number of exemplar rejected due to not being out of the expected order.
  // TYPE counter
  target_scrapes_exemplar_out_of_order_total: metric('prometheus_target_scrapes_exemplar_out_of_order_total'),

  // HELP Total number of samples rejected due to duplicate timestamps but different values.
  // TYPE counter
  target_scrapes_sample_duplicate_timestamp_total: metric('prometheus_target_scrapes_sample_duplicate_timestamp_total'),

  // HELP Total number of samples rejected due to timestamp falling outside of the time bounds.
  // TYPE counter
  target_scrapes_sample_out_of_bounds_total: metric('prometheus_target_scrapes_sample_out_of_bounds_total'),

  // HELP Total number of samples rejected due to not being out of the expected order.
  // TYPE counter
  target_scrapes_sample_out_of_order_total: metric('prometheus_target_scrapes_sample_out_of_order_total'),

  // HELP The total number of template text expansion failures.
  // TYPE counter
  template_text_expansion_failures_total: metric('prometheus_template_text_expansion_failures_total'),

  // HELP The total number of template text expansions.
  // TYPE counter
  template_text_expansions_total: metric('prometheus_template_text_expansions_total'),

  // HELP The current number of watcher goroutines.
  // TYPE gauge
  treecache_watcher_goroutines: metric('prometheus_treecache_watcher_goroutines'),

  // HELP The total number of ZooKeeper failures.
  // TYPE counter
  treecache_zookeeper_failures_total: metric('prometheus_treecache_zookeeper_failures_total'),

  // HELP Number of currently loaded data blocks
  // TYPE gauge
  tsdb_blocks_loaded: metric('prometheus_tsdb_blocks_loaded'),

  // HELP Total number of checkpoint creations that failed.
  // TYPE counter
  tsdb_checkpoint_creations_failed_total: metric('prometheus_tsdb_checkpoint_creations_failed_total'),

  // HELP Total number of checkpoint creations attempted.
  // TYPE counter
  tsdb_checkpoint_creations_total: metric('prometheus_tsdb_checkpoint_creations_total'),

  // HELP Total number of checkpoint deletions that failed.
  // TYPE counter
  tsdb_checkpoint_deletions_failed_total: metric('prometheus_tsdb_checkpoint_deletions_failed_total'),

  // HELP Total number of checkpoint deletions attempted.
  // TYPE counter
  tsdb_checkpoint_deletions_total: metric('prometheus_tsdb_checkpoint_deletions_total'),

  // HELP -1: lockfile is disabled. 0: a lockfile from a previous execution was replaced. 1: lockfile creation was clean
  // TYPE gauge
  tsdb_clean_start: metric('prometheus_tsdb_clean_start'),

  // HELP Final time range of chunks on their first compaction
  // TYPE histogram
  tsdb_compaction_chunk_range_seconds: metric('prometheus_tsdb_compaction_chunk_range_seconds'),

  // HELP Final number of samples on their first compaction
  // TYPE histogram
  tsdb_compaction_chunk_samples: metric('prometheus_tsdb_compaction_chunk_samples'),

  // HELP Final size of chunks on their first compaction
  // TYPE histogram
  tsdb_compaction_chunk_size_bytes: metric('prometheus_tsdb_compaction_chunk_size_bytes'),

  // HELP Duration of compaction runs
  // TYPE histogram
  tsdb_compaction_duration_seconds: metric('prometheus_tsdb_compaction_duration_seconds'),

  // HELP Set to 1 when a block is currently being written to the disk.
  // TYPE gauge
  tsdb_compaction_populating_block: metric('prometheus_tsdb_compaction_populating_block'),

  // HELP Total number of compactions that failed for the partition.
  // TYPE counter
  tsdb_compactions_failed_total: metric('prometheus_tsdb_compactions_failed_total'),

  // HELP Total number of skipped compactions due to disabled auto compaction.
  // TYPE counter
  tsdb_compactions_skipped_total: metric('prometheus_tsdb_compactions_skipped_total'),

  // HELP Total number of compactions that were executed for the partition.
  // TYPE counter
  tsdb_compactions_total: metric('prometheus_tsdb_compactions_total'),

  // HELP Total number of triggered compactions for the partition.
  // TYPE counter
  tsdb_compactions_triggered_total: metric('prometheus_tsdb_compactions_triggered_total'),

  // HELP Time taken to replay the data on disk.
  // TYPE gauge
  tsdb_data_replay_duration_seconds: metric('prometheus_tsdb_data_replay_duration_seconds'),

  // HELP Total number of appended exemplars.
  // TYPE counter
  tsdb_exemplar_exemplars_appended_total: metric('prometheus_tsdb_exemplar_exemplars_appended_total'),

  // HELP Number of exemplars currently in circular storage.
  // TYPE gauge
  tsdb_exemplar_exemplars_in_storage: metric('prometheus_tsdb_exemplar_exemplars_in_storage'),

  // HELP The timestamp of the oldest exemplar stored in circular storage. Useful to check for what timerange the current exemplar buffer limit allows. This usually means the last timestampfor all exemplars for a typical setup. This is not true though if one of the series timestamp is in future compared to rest series.
  // TYPE gauge
  tsdb_exemplar_last_exemplars_timestamp_seconds: metric('prometheus_tsdb_exemplar_last_exemplars_timestamp_seconds'),

  // HELP Total number of exemplars the exemplar storage can store, resizeable.
  // TYPE gauge
  tsdb_exemplar_max_exemplars: metric('prometheus_tsdb_exemplar_max_exemplars'),

  // HELP Total number of out of order exemplar ingestion failed attempts.
  // TYPE counter
  tsdb_exemplar_out_of_order_exemplars_total: metric('prometheus_tsdb_exemplar_out_of_order_exemplars_total'),

  // HELP Number of series with exemplars currently in circular storage.
  // TYPE gauge
  tsdb_exemplar_series_with_exemplars_in_storage: metric('prometheus_tsdb_exemplar_series_with_exemplars_in_storage'),

  // HELP Number of currently active appender transactions
  // TYPE gauge
  tsdb_head_active_appenders: metric('prometheus_tsdb_head_active_appenders'),

  // HELP Total number of chunks in the head block.
  // TYPE gauge
  tsdb_head_chunks: metric('prometheus_tsdb_head_chunks'),

  // HELP Total number of chunks created in the head
  // TYPE counter
  tsdb_head_chunks_created_total: metric('prometheus_tsdb_head_chunks_created_total'),

  // HELP Total number of chunks removed in the head
  // TYPE counter
  tsdb_head_chunks_removed_total: metric('prometheus_tsdb_head_chunks_removed_total'),

  // HELP Size of the chunks_head directory.
  // TYPE gauge
  tsdb_head_chunks_storage_size_bytes: metric('prometheus_tsdb_head_chunks_storage_size_bytes'),

  // HELP Runtime of garbage collection in the head block.
  // TYPE summary
  tsdb_head_gc_duration_seconds: metric('prometheus_tsdb_head_gc_duration_seconds'),

  // HELP Maximum timestamp of the head block. The unit is decided by the library consumer.
  // TYPE gauge
  tsdb_head_max_time: metric('prometheus_tsdb_head_max_time'),

  // HELP Maximum timestamp of the head block.
  // TYPE gauge
  tsdb_head_max_time_seconds: metric('prometheus_tsdb_head_max_time_seconds'),

  // HELP Minimum time bound of the head block. The unit is decided by the library consumer.
  // TYPE gauge
  tsdb_head_min_time: metric('prometheus_tsdb_head_min_time'),

  // HELP Minimum time bound of the head block.
  // TYPE gauge
  tsdb_head_min_time_seconds: metric('prometheus_tsdb_head_min_time_seconds'),

  // HELP Total number of series in the head block.
  // TYPE gauge
  tsdb_head_series: metric('prometheus_tsdb_head_series'),

  // HELP Total number of series created in the head
  // TYPE counter
  tsdb_head_series_created_total: metric('prometheus_tsdb_head_series_created_total'),

  // HELP Total number of requests for series that were not found.
  // TYPE counter
  tsdb_head_series_not_found_total: metric('prometheus_tsdb_head_series_not_found_total'),

  // HELP Total number of series removed in the head
  // TYPE counter
  tsdb_head_series_removed_total: metric('prometheus_tsdb_head_series_removed_total'),

  // HELP Total number of head truncations that failed.
  // TYPE counter
  tsdb_head_truncations_failed_total: metric('prometheus_tsdb_head_truncations_failed_total'),

  // HELP Total number of head truncations attempted.
  // TYPE counter
  tsdb_head_truncations_total: metric('prometheus_tsdb_head_truncations_total'),

  // HELP The highest TSDB append ID that has been given out.
  // TYPE gauge
  tsdb_isolation_high_watermark: metric('prometheus_tsdb_isolation_high_watermark'),

  // HELP The lowest TSDB append ID that is still referenced.
  // TYPE gauge
  tsdb_isolation_low_watermark: metric('prometheus_tsdb_isolation_low_watermark'),

  // HELP Lowest timestamp value stored in the database. The unit is decided by the library consumer.
  // TYPE gauge
  tsdb_lowest_timestamp: metric('prometheus_tsdb_lowest_timestamp'),

  // HELP Lowest timestamp value stored in the database.
  // TYPE gauge
  tsdb_lowest_timestamp_seconds: metric('prometheus_tsdb_lowest_timestamp_seconds'),

  // HELP Total number of memory-mapped chunk corruptions.
  // TYPE counter
  tsdb_mmap_chunk_corruptions_total: metric('prometheus_tsdb_mmap_chunk_corruptions_total'),

  // HELP Total number of chunks that were memory-mapped.
  // TYPE counter
  tsdb_mmap_chunks_total: metric('prometheus_tsdb_mmap_chunks_total'),

  // HELP Number of times the database failed to reloadBlocks block data from disk.
  // TYPE counter
  tsdb_reloads_failures_total: metric('prometheus_tsdb_reloads_failures_total'),

  // HELP Number of times the database reloaded block data from disk.
  // TYPE counter
  tsdb_reloads_total: metric('prometheus_tsdb_reloads_total'),

  // HELP Max number of bytes to be retained in the tsdb blocks, configured 0 means disabled
  // TYPE gauge
  tsdb_retention_limit_bytes: metric('prometheus_tsdb_retention_limit_bytes'),

  // HELP How long to retain samples in storage.
  // TYPE gauge
  tsdb_retention_limit_seconds: metric('prometheus_tsdb_retention_limit_seconds'),

  // HELP The number of times that blocks were deleted because the maximum number of bytes was exceeded.
  // TYPE counter
  tsdb_size_retentions_total: metric('prometheus_tsdb_size_retentions_total'),

  // HELP Total number snapshot replays that failed.
  // TYPE counter
  tsdb_snapshot_replay_error_total: metric('prometheus_tsdb_snapshot_replay_error_total'),

  // HELP The number of bytes that are currently used for local storage by all blocks.
  // TYPE gauge
  tsdb_storage_blocks_bytes: metric('prometheus_tsdb_storage_blocks_bytes'),

  // HELP Size of symbol table in memory for loaded blocks
  // TYPE gauge
  tsdb_symbol_table_size_bytes: metric('prometheus_tsdb_symbol_table_size_bytes'),

  // HELP The number of times that blocks were deleted because the maximum time limit was exceeded.
  // TYPE counter
  tsdb_time_retentions_total: metric('prometheus_tsdb_time_retentions_total'),

  // HELP The time taken to recompact blocks to remove tombstones.
  // TYPE histogram
  tsdb_tombstone_cleanup_seconds: metric('prometheus_tsdb_tombstone_cleanup_seconds'),

  // HELP Total number of compactions done on overlapping blocks.
  // TYPE counter
  tsdb_vertical_compactions_total: metric('prometheus_tsdb_vertical_compactions_total'),

  // HELP Total number of completed pages.
  // TYPE counter
  tsdb_wal_completed_pages_total: metric('prometheus_tsdb_wal_completed_pages_total'),

  // HELP Total number of WAL corruptions.
  // TYPE counter
  tsdb_wal_corruptions_total: metric('prometheus_tsdb_wal_corruptions_total'),

  // HELP Duration of write log fsync.
  // TYPE summary
  tsdb_wal_fsync_duration_seconds: metric('prometheus_tsdb_wal_fsync_duration_seconds'),

  // HELP Total number of page flushes.
  // TYPE counter
  tsdb_wal_page_flushes_total: metric('prometheus_tsdb_wal_page_flushes_total'),

  // HELP Write log segment index that TSDB is currently writing to.
  // TYPE gauge
  tsdb_wal_segment_current: metric('prometheus_tsdb_wal_segment_current'),

  // HELP Size of the write log directory.
  // TYPE gauge
  tsdb_wal_storage_size_bytes: metric('prometheus_tsdb_wal_storage_size_bytes'),

  // HELP Duration of WAL truncation.
  // TYPE summary
  tsdb_wal_truncate_duration_seconds: metric('prometheus_tsdb_wal_truncate_duration_seconds'),

  // HELP Total number of write log truncations that failed.
  // TYPE counter
  tsdb_wal_truncations_failed_total: metric('prometheus_tsdb_wal_truncations_failed_total'),

  // HELP Total number of write log truncations attempted.
  // TYPE counter
  tsdb_wal_truncations_total: metric('prometheus_tsdb_wal_truncations_total'),

  // HELP Total number of write log writes that failed.
  // TYPE counter
  tsdb_wal_writes_failed_total: metric('prometheus_tsdb_wal_writes_failed_total'),

  // HELP Total number of errors that occurred while sending federation responses.
  // TYPE counter
  web_federation_errors_total: metric('prometheus_web_federation_errors_total'),

  // HELP Total number of warnings that occurred while sending federation responses.
  // TYPE counter
  web_federation_warnings_total: metric('prometheus_web_federation_warnings_total'),
};

prometheus
