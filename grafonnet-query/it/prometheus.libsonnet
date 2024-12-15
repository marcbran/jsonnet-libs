local metric(name, type, help) = {
  local metric = self,
  local eq(value) = { expr(field): '%s%s"%s"' % [field, '=', value] },
  _: {
    kind: 'metric',
    metric: name,
    type: type,
    help: help,
    rawMatchers: { [field]: metric[field] for field in std.objectFields(metric) if field != '_' },
    match(matchers): metric { _+: { rawMatchers+: matchers } },
    expr:
      local labels = [[field, self.rawMatchers[field]] for field in std.sort(std.objectFields(self.rawMatchers))];
      local operators = [[label[0], if std.type(label[1]) == 'object' then label[1] else eq(label[1])] for label in labels];
      local matchers = [operator[1].expr(operator[0]) for operator in operators];
      local matcherString = std.join(', ', matchers);
      if std.length(matcherString) > 0 then '%s{%s}' % [name, matcherString] else name,
  },
};

local prometheus = {
  // TYPE gauge
  // HELP The current number of remote read queries being executed or waiting.
  api_remote_read_queries: metric('prometheus_api_remote_read_queries', 'GAUGE', 'The current number of remote read queries being executed or waiting.'),

  // TYPE gauge
  // HELP A metric with a constant '1' value labeled by version, revision, branch, goversion from which prometheus was built, and the goos and goarch for the build.
  build_info: metric('prometheus_build_info', 'GAUGE', 'A metric with a constant 1 value labeled by version, revision, branch, goversion from which prometheus was built, and the goos and goarch for the build.'),

  // TYPE gauge
  // HELP Timestamp of the last successful configuration reload.
  config_last_reload_success_timestamp_seconds: metric('prometheus_config_last_reload_success_timestamp_seconds', 'GAUGE', 'Timestamp of the last successful configuration reload.'),

  // TYPE gauge
  // HELP Whether the last configuration reload attempt was successful.
  config_last_reload_successful: metric('prometheus_config_last_reload_successful', 'GAUGE', 'Whether the last configuration reload attempt was successful.'),

  // TYPE gauge
  // HELP The current number of queries being executed or waiting.
  engine_queries: metric('prometheus_engine_queries', 'GAUGE', 'The current number of queries being executed or waiting.'),

  // TYPE gauge
  // HELP The max number of concurrent queries.
  engine_queries_concurrent_max: metric('prometheus_engine_queries_concurrent_max', 'GAUGE', 'The max number of concurrent queries.'),

  // TYPE summary
  // HELP Query timings
  engine_query_duration_seconds: metric('prometheus_engine_query_duration_seconds', 'SUMMARY', 'Query timings'),

  // TYPE gauge
  // HELP State of the query log.
  engine_query_log_enabled: metric('prometheus_engine_query_log_enabled', 'GAUGE', 'State of the query log.'),

  // TYPE counter
  // HELP The number of query log failures.
  engine_query_log_failures_total: metric('prometheus_engine_query_log_failures_total', 'COUNTER', 'The number of query log failures.'),

  // TYPE counter
  // HELP The total number of samples loaded by all queries.
  engine_query_samples_total: metric('prometheus_engine_query_samples_total', 'COUNTER', 'The total number of samples loaded by all queries.'),

  // TYPE histogram
  // HELP Histogram of latencies for HTTP requests.
  http_request_duration_seconds: metric('prometheus_http_request_duration_seconds', 'HISTOGRAM', 'Histogram of latencies for HTTP requests.'),

  // TYPE counter
  // HELP Counter of HTTP requests.
  http_requests_total: metric('prometheus_http_requests_total', 'COUNTER', 'Counter of HTTP requests.'),

  // TYPE histogram
  // HELP Histogram of response size for HTTP requests.
  http_response_size_bytes: metric('prometheus_http_response_size_bytes', 'HISTOGRAM', 'Histogram of response size for HTTP requests.'),

  // TYPE gauge
  // HELP The number of alertmanagers discovered and active.
  notifications_alertmanagers_discovered: metric('prometheus_notifications_alertmanagers_discovered', 'GAUGE', 'The number of alertmanagers discovered and active.'),

  // TYPE counter
  // HELP Total number of alerts dropped due to errors when sending to Alertmanager.
  notifications_dropped_total: metric('prometheus_notifications_dropped_total', 'COUNTER', 'Total number of alerts dropped due to errors when sending to Alertmanager.'),

  // TYPE gauge
  // HELP The capacity of the alert notifications queue.
  notifications_queue_capacity: metric('prometheus_notifications_queue_capacity', 'GAUGE', 'The capacity of the alert notifications queue.'),

  // TYPE gauge
  // HELP The number of alert notifications in the queue.
  notifications_queue_length: metric('prometheus_notifications_queue_length', 'GAUGE', 'The number of alert notifications in the queue.'),

  // TYPE gauge
  // HELP Whether Prometheus startup was fully completed and the server is ready for normal operation.
  ready: metric('prometheus_ready', 'GAUGE', 'Whether Prometheus startup was fully completed and the server is ready for normal operation.'),

  // TYPE counter
  // HELP Exemplars in to remote storage, compare to exemplars out for queue managers.
  remote_storage_exemplars_in_total: metric('prometheus_remote_storage_exemplars_in_total', 'COUNTER', 'Exemplars in to remote storage, compare to exemplars out for queue managers.'),

  // TYPE gauge
  // HELP Highest timestamp that has come into the remote storage via the Appender interface, in seconds since epoch.
  remote_storage_highest_timestamp_in_seconds: metric('prometheus_remote_storage_highest_timestamp_in_seconds', 'GAUGE', 'Highest timestamp that has come into the remote storage via the Appender interface, in seconds since epoch.'),

  // TYPE counter
  // HELP HistogramSamples in to remote storage, compare to histograms out for queue managers.
  remote_storage_histograms_in_total: metric('prometheus_remote_storage_histograms_in_total', 'COUNTER', 'HistogramSamples in to remote storage, compare to histograms out for queue managers.'),

  // TYPE counter
  // HELP Samples in to remote storage, compare to samples out for queue managers.
  remote_storage_samples_in_total: metric('prometheus_remote_storage_samples_in_total', 'COUNTER', 'Samples in to remote storage, compare to samples out for queue managers.'),

  // TYPE counter
  // HELP The number of times release has been called for strings that are not interned.
  remote_storage_string_interner_zero_reference_releases_total: metric('prometheus_remote_storage_string_interner_zero_reference_releases_total', 'COUNTER', 'The number of times release has been called for strings that are not interned.'),

  // TYPE summary
  // HELP The duration for a rule to execute.
  rule_evaluation_duration_seconds: metric('prometheus_rule_evaluation_duration_seconds', 'SUMMARY', 'The duration for a rule to execute.'),

  // TYPE summary
  // HELP The duration of rule group evaluations.
  rule_group_duration_seconds: metric('prometheus_rule_group_duration_seconds', 'SUMMARY', 'The duration of rule group evaluations.'),

  // TYPE counter
  // HELP Number of cache hit during refresh.
  sd_azure_cache_hit_total: metric('prometheus_sd_azure_cache_hit_total', 'COUNTER', 'Number of cache hit during refresh.'),

  // TYPE counter
  // HELP Number of Azure service discovery refresh failures.
  sd_azure_failures_total: metric('prometheus_sd_azure_failures_total', 'COUNTER', 'Number of Azure service discovery refresh failures.'),

  // TYPE summary
  // HELP The duration of a Consul RPC call in seconds.
  sd_consul_rpc_duration_seconds: metric('prometheus_sd_consul_rpc_duration_seconds', 'SUMMARY', 'The duration of a Consul RPC call in seconds.'),

  // TYPE counter
  // HELP The number of Consul RPC call failures.
  sd_consul_rpc_failures_total: metric('prometheus_sd_consul_rpc_failures_total', 'COUNTER', 'The number of Consul RPC call failures.'),

  // TYPE gauge
  // HELP Current number of discovered targets.
  sd_discovered_targets: metric('prometheus_sd_discovered_targets', 'GAUGE', 'Current number of discovered targets.'),

  // TYPE counter
  // HELP The number of DNS-SD lookup failures.
  sd_dns_lookup_failures_total: metric('prometheus_sd_dns_lookup_failures_total', 'COUNTER', 'The number of DNS-SD lookup failures.'),

  // TYPE counter
  // HELP The number of DNS-SD lookups.
  sd_dns_lookups_total: metric('prometheus_sd_dns_lookups_total', 'COUNTER', 'The number of DNS-SD lookups.'),

  // TYPE gauge
  // HELP Current number of service discovery configurations that failed to load.
  sd_failed_configs: metric('prometheus_sd_failed_configs', 'GAUGE', 'Current number of service discovery configurations that failed to load.'),

  // TYPE counter
  // HELP The number of File-SD read errors.
  sd_file_read_errors_total: metric('prometheus_sd_file_read_errors_total', 'COUNTER', 'The number of File-SD read errors.'),

  // TYPE summary
  // HELP The duration of the File-SD scan in seconds.
  sd_file_scan_duration_seconds: metric('prometheus_sd_file_scan_duration_seconds', 'SUMMARY', 'The duration of the File-SD scan in seconds.'),

  // TYPE counter
  // HELP The number of File-SD errors caused by filesystem watch failures.
  sd_file_watcher_errors_total: metric('prometheus_sd_file_watcher_errors_total', 'COUNTER', 'The number of File-SD errors caused by filesystem watch failures.'),

  // TYPE counter
  // HELP Number of HTTP service discovery refresh failures.
  sd_http_failures_total: metric('prometheus_sd_http_failures_total', 'COUNTER', 'Number of HTTP service discovery refresh failures.'),

  // TYPE counter
  // HELP The number of Kubernetes events handled.
  sd_kubernetes_events_total: metric('prometheus_sd_kubernetes_events_total', 'COUNTER', 'The number of Kubernetes events handled.'),

  // TYPE counter
  // HELP The number of failed WATCH/LIST requests.
  sd_kubernetes_failures_total: metric('prometheus_sd_kubernetes_failures_total', 'COUNTER', 'The number of failed WATCH/LIST requests.'),

  // TYPE summary
  // HELP The duration of a Kuma MADS fetch call.
  sd_kuma_fetch_duration_seconds: metric('prometheus_sd_kuma_fetch_duration_seconds', 'SUMMARY', 'The duration of a Kuma MADS fetch call.'),

  // TYPE counter
  // HELP The number of Kuma MADS fetch call failures.
  sd_kuma_fetch_failures_total: metric('prometheus_sd_kuma_fetch_failures_total', 'COUNTER', 'The number of Kuma MADS fetch call failures.'),

  // TYPE counter
  // HELP The number of Kuma MADS fetch calls that result in no updates to the targets.
  sd_kuma_fetch_skipped_updates_total: metric('prometheus_sd_kuma_fetch_skipped_updates_total', 'COUNTER', 'The number of Kuma MADS fetch calls that result in no updates to the targets.'),

  // TYPE counter
  // HELP Number of Linode service discovery refresh failures.
  sd_linode_failures_total: metric('prometheus_sd_linode_failures_total', 'COUNTER', 'Number of Linode service discovery refresh failures.'),

  // TYPE counter
  // HELP Number of nomad service discovery refresh failures.
  sd_nomad_failures_total: metric('prometheus_sd_nomad_failures_total', 'COUNTER', 'Number of nomad service discovery refresh failures.'),

  // TYPE counter
  // HELP Total number of update events received from the SD providers.
  sd_received_updates_total: metric('prometheus_sd_received_updates_total', 'COUNTER', 'Total number of update events received from the SD providers.'),

  // TYPE counter
  // HELP Total number of update events that couldn't be sent immediately.
  sd_updates_delayed_total: metric('prometheus_sd_updates_delayed_total', 'COUNTER', 'Total number of update events that couldnt be sent immediately.'),

  // TYPE counter
  // HELP Total number of update events sent to the SD consumers.
  sd_updates_total: metric('prometheus_sd_updates_total', 'COUNTER', 'Total number of update events sent to the SD consumers.'),

  // TYPE summary
  // HELP Actual intervals between scrapes.
  target_interval_length_seconds: metric('prometheus_target_interval_length_seconds', 'SUMMARY', 'Actual intervals between scrapes.'),

  // TYPE gauge
  // HELP The number of bytes that are currently used for storing metric metadata in the cache
  target_metadata_cache_bytes: metric('prometheus_target_metadata_cache_bytes', 'GAUGE', 'The number of bytes that are currently used for storing metric metadata in the cache'),

  // TYPE gauge
  // HELP Total number of metric metadata entries in the cache
  target_metadata_cache_entries: metric('prometheus_target_metadata_cache_entries', 'GAUGE', 'Total number of metric metadata entries in the cache'),

  // TYPE counter
  // HELP Total number of times scrape pools hit the label limits, during sync or config reload.
  target_scrape_pool_exceeded_label_limits_total: metric('prometheus_target_scrape_pool_exceeded_label_limits_total', 'COUNTER', 'Total number of times scrape pools hit the label limits, during sync or config reload.'),

  // TYPE counter
  // HELP Total number of times scrape pools hit the target limit, during sync or config reload.
  target_scrape_pool_exceeded_target_limit_total: metric('prometheus_target_scrape_pool_exceeded_target_limit_total', 'COUNTER', 'Total number of times scrape pools hit the target limit, during sync or config reload.'),

  // TYPE counter
  // HELP Total number of failed scrape pool reloads.
  target_scrape_pool_reloads_failed_total: metric('prometheus_target_scrape_pool_reloads_failed_total', 'COUNTER', 'Total number of failed scrape pool reloads.'),

  // TYPE counter
  // HELP Total number of scrape pool reloads.
  target_scrape_pool_reloads_total: metric('prometheus_target_scrape_pool_reloads_total', 'COUNTER', 'Total number of scrape pool reloads.'),

  // TYPE counter
  // HELP Total number of syncs that were executed on a scrape pool.
  target_scrape_pool_sync_total: metric('prometheus_target_scrape_pool_sync_total', 'COUNTER', 'Total number of syncs that were executed on a scrape pool.'),

  // TYPE gauge
  // HELP Maximum number of targets allowed in this scrape pool.
  target_scrape_pool_target_limit: metric('prometheus_target_scrape_pool_target_limit', 'GAUGE', 'Maximum number of targets allowed in this scrape pool.'),

  // TYPE gauge
  // HELP Current number of targets in this scrape pool.
  target_scrape_pool_targets: metric('prometheus_target_scrape_pool_targets', 'GAUGE', 'Current number of targets in this scrape pool.'),

  // TYPE counter
  // HELP Total number of scrape pool creations that failed.
  target_scrape_pools_failed_total: metric('prometheus_target_scrape_pools_failed_total', 'COUNTER', 'Total number of scrape pool creations that failed.'),

  // TYPE counter
  // HELP Total number of scrape pool creation attempts.
  target_scrape_pools_total: metric('prometheus_target_scrape_pools_total', 'COUNTER', 'Total number of scrape pool creation attempts.'),

  // TYPE counter
  // HELP How many times a scrape cache was flushed due to getting big while scrapes are failing.
  target_scrapes_cache_flush_forced_total: metric('prometheus_target_scrapes_cache_flush_forced_total', 'COUNTER', 'How many times a scrape cache was flushed due to getting big while scrapes are failing.'),

  // TYPE counter
  // HELP Total number of scrapes that hit the body size limit
  target_scrapes_exceeded_body_size_limit_total: metric('prometheus_target_scrapes_exceeded_body_size_limit_total', 'COUNTER', 'Total number of scrapes that hit the body size limit'),

  // TYPE counter
  // HELP Total number of scrapes that hit the native histogram bucket limit and were rejected.
  target_scrapes_exceeded_native_histogram_bucket_limit_total: metric('prometheus_target_scrapes_exceeded_native_histogram_bucket_limit_total', 'COUNTER', 'Total number of scrapes that hit the native histogram bucket limit and were rejected.'),

  // TYPE counter
  // HELP Total number of scrapes that hit the sample limit and were rejected.
  target_scrapes_exceeded_sample_limit_total: metric('prometheus_target_scrapes_exceeded_sample_limit_total', 'COUNTER', 'Total number of scrapes that hit the sample limit and were rejected.'),

  // TYPE counter
  // HELP Total number of exemplar rejected due to not being out of the expected order.
  target_scrapes_exemplar_out_of_order_total: metric('prometheus_target_scrapes_exemplar_out_of_order_total', 'COUNTER', 'Total number of exemplar rejected due to not being out of the expected order.'),

  // TYPE counter
  // HELP Total number of samples rejected due to duplicate timestamps but different values.
  target_scrapes_sample_duplicate_timestamp_total: metric('prometheus_target_scrapes_sample_duplicate_timestamp_total', 'COUNTER', 'Total number of samples rejected due to duplicate timestamps but different values.'),

  // TYPE counter
  // HELP Total number of samples rejected due to timestamp falling outside of the time bounds.
  target_scrapes_sample_out_of_bounds_total: metric('prometheus_target_scrapes_sample_out_of_bounds_total', 'COUNTER', 'Total number of samples rejected due to timestamp falling outside of the time bounds.'),

  // TYPE counter
  // HELP Total number of samples rejected due to not being out of the expected order.
  target_scrapes_sample_out_of_order_total: metric('prometheus_target_scrapes_sample_out_of_order_total', 'COUNTER', 'Total number of samples rejected due to not being out of the expected order.'),

  // TYPE counter
  // HELP Total number of target sync failures.
  target_sync_failed_total: metric('prometheus_target_sync_failed_total', 'COUNTER', 'Total number of target sync failures.'),

  // TYPE summary
  // HELP Actual interval to sync the scrape pool.
  target_sync_length_seconds: metric('prometheus_target_sync_length_seconds', 'SUMMARY', 'Actual interval to sync the scrape pool.'),

  // TYPE counter
  // HELP The total number of template text expansion failures.
  template_text_expansion_failures_total: metric('prometheus_template_text_expansion_failures_total', 'COUNTER', 'The total number of template text expansion failures.'),

  // TYPE counter
  // HELP The total number of template text expansions.
  template_text_expansions_total: metric('prometheus_template_text_expansions_total', 'COUNTER', 'The total number of template text expansions.'),

  // TYPE gauge
  // HELP The current number of watcher goroutines.
  treecache_watcher_goroutines: metric('prometheus_treecache_watcher_goroutines', 'GAUGE', 'The current number of watcher goroutines.'),

  // TYPE counter
  // HELP The total number of ZooKeeper failures.
  treecache_zookeeper_failures_total: metric('prometheus_treecache_zookeeper_failures_total', 'COUNTER', 'The total number of ZooKeeper failures.'),

  // TYPE gauge
  // HELP Number of currently loaded data blocks
  tsdb_blocks_loaded: metric('prometheus_tsdb_blocks_loaded', 'GAUGE', 'Number of currently loaded data blocks'),

  // TYPE counter
  // HELP Total number of checkpoint creations that failed.
  tsdb_checkpoint_creations_failed_total: metric('prometheus_tsdb_checkpoint_creations_failed_total', 'COUNTER', 'Total number of checkpoint creations that failed.'),

  // TYPE counter
  // HELP Total number of checkpoint creations attempted.
  tsdb_checkpoint_creations_total: metric('prometheus_tsdb_checkpoint_creations_total', 'COUNTER', 'Total number of checkpoint creations attempted.'),

  // TYPE counter
  // HELP Total number of checkpoint deletions that failed.
  tsdb_checkpoint_deletions_failed_total: metric('prometheus_tsdb_checkpoint_deletions_failed_total', 'COUNTER', 'Total number of checkpoint deletions that failed.'),

  // TYPE counter
  // HELP Total number of checkpoint deletions attempted.
  tsdb_checkpoint_deletions_total: metric('prometheus_tsdb_checkpoint_deletions_total', 'COUNTER', 'Total number of checkpoint deletions attempted.'),

  // TYPE gauge
  // HELP -1: lockfile is disabled. 0: a lockfile from a previous execution was replaced. 1: lockfile creation was clean
  tsdb_clean_start: metric('prometheus_tsdb_clean_start', 'GAUGE', '-1: lockfile is disabled. 0: a lockfile from a previous execution was replaced. 1: lockfile creation was clean'),

  // TYPE histogram
  // HELP Final time range of chunks on their first compaction
  tsdb_compaction_chunk_range_seconds: metric('prometheus_tsdb_compaction_chunk_range_seconds', 'HISTOGRAM', 'Final time range of chunks on their first compaction'),

  // TYPE histogram
  // HELP Final number of samples on their first compaction
  tsdb_compaction_chunk_samples: metric('prometheus_tsdb_compaction_chunk_samples', 'HISTOGRAM', 'Final number of samples on their first compaction'),

  // TYPE histogram
  // HELP Final size of chunks on their first compaction
  tsdb_compaction_chunk_size_bytes: metric('prometheus_tsdb_compaction_chunk_size_bytes', 'HISTOGRAM', 'Final size of chunks on their first compaction'),

  // TYPE histogram
  // HELP Duration of compaction runs
  tsdb_compaction_duration_seconds: metric('prometheus_tsdb_compaction_duration_seconds', 'HISTOGRAM', 'Duration of compaction runs'),

  // TYPE gauge
  // HELP Set to 1 when a block is currently being written to the disk.
  tsdb_compaction_populating_block: metric('prometheus_tsdb_compaction_populating_block', 'GAUGE', 'Set to 1 when a block is currently being written to the disk.'),

  // TYPE counter
  // HELP Total number of compactions that failed for the partition.
  tsdb_compactions_failed_total: metric('prometheus_tsdb_compactions_failed_total', 'COUNTER', 'Total number of compactions that failed for the partition.'),

  // TYPE counter
  // HELP Total number of skipped compactions due to disabled auto compaction.
  tsdb_compactions_skipped_total: metric('prometheus_tsdb_compactions_skipped_total', 'COUNTER', 'Total number of skipped compactions due to disabled auto compaction.'),

  // TYPE counter
  // HELP Total number of compactions that were executed for the partition.
  tsdb_compactions_total: metric('prometheus_tsdb_compactions_total', 'COUNTER', 'Total number of compactions that were executed for the partition.'),

  // TYPE counter
  // HELP Total number of triggered compactions for the partition.
  tsdb_compactions_triggered_total: metric('prometheus_tsdb_compactions_triggered_total', 'COUNTER', 'Total number of triggered compactions for the partition.'),

  // TYPE gauge
  // HELP Time taken to replay the data on disk.
  tsdb_data_replay_duration_seconds: metric('prometheus_tsdb_data_replay_duration_seconds', 'GAUGE', 'Time taken to replay the data on disk.'),

  // TYPE counter
  // HELP Total number of appended exemplars.
  tsdb_exemplar_exemplars_appended_total: metric('prometheus_tsdb_exemplar_exemplars_appended_total', 'COUNTER', 'Total number of appended exemplars.'),

  // TYPE gauge
  // HELP Number of exemplars currently in circular storage.
  tsdb_exemplar_exemplars_in_storage: metric('prometheus_tsdb_exemplar_exemplars_in_storage', 'GAUGE', 'Number of exemplars currently in circular storage.'),

  // TYPE gauge
  // HELP The timestamp of the oldest exemplar stored in circular storage. Useful to check for what timerange the current exemplar buffer limit allows. This usually means the last timestampfor all exemplars for a typical setup. This is not true though if one of the series timestamp is in future compared to rest series.
  tsdb_exemplar_last_exemplars_timestamp_seconds: metric('prometheus_tsdb_exemplar_last_exemplars_timestamp_seconds', 'GAUGE', 'The timestamp of the oldest exemplar stored in circular storage. Useful to check for what timerange the current exemplar buffer limit allows. This usually means the last timestampfor all exemplars for a typical setup. This is not true though if one of the series timestamp is in future compared to rest series.'),

  // TYPE gauge
  // HELP Total number of exemplars the exemplar storage can store, resizeable.
  tsdb_exemplar_max_exemplars: metric('prometheus_tsdb_exemplar_max_exemplars', 'GAUGE', 'Total number of exemplars the exemplar storage can store, resizeable.'),

  // TYPE counter
  // HELP Total number of out of order exemplar ingestion failed attempts.
  tsdb_exemplar_out_of_order_exemplars_total: metric('prometheus_tsdb_exemplar_out_of_order_exemplars_total', 'COUNTER', 'Total number of out of order exemplar ingestion failed attempts.'),

  // TYPE gauge
  // HELP Number of series with exemplars currently in circular storage.
  tsdb_exemplar_series_with_exemplars_in_storage: metric('prometheus_tsdb_exemplar_series_with_exemplars_in_storage', 'GAUGE', 'Number of series with exemplars currently in circular storage.'),

  // TYPE gauge
  // HELP Number of currently active appender transactions
  tsdb_head_active_appenders: metric('prometheus_tsdb_head_active_appenders', 'GAUGE', 'Number of currently active appender transactions'),

  // TYPE gauge
  // HELP Total number of chunks in the head block.
  tsdb_head_chunks: metric('prometheus_tsdb_head_chunks', 'GAUGE', 'Total number of chunks in the head block.'),

  // TYPE counter
  // HELP Total number of chunks created in the head
  tsdb_head_chunks_created_total: metric('prometheus_tsdb_head_chunks_created_total', 'COUNTER', 'Total number of chunks created in the head'),

  // TYPE counter
  // HELP Total number of chunks removed in the head
  tsdb_head_chunks_removed_total: metric('prometheus_tsdb_head_chunks_removed_total', 'COUNTER', 'Total number of chunks removed in the head'),

  // TYPE gauge
  // HELP Size of the chunks_head directory.
  tsdb_head_chunks_storage_size_bytes: metric('prometheus_tsdb_head_chunks_storage_size_bytes', 'GAUGE', 'Size of the chunks_head directory.'),

  // TYPE summary
  // HELP Runtime of garbage collection in the head block.
  tsdb_head_gc_duration_seconds: metric('prometheus_tsdb_head_gc_duration_seconds', 'SUMMARY', 'Runtime of garbage collection in the head block.'),

  // TYPE gauge
  // HELP Maximum timestamp of the head block. The unit is decided by the library consumer.
  tsdb_head_max_time: metric('prometheus_tsdb_head_max_time', 'GAUGE', 'Maximum timestamp of the head block. The unit is decided by the library consumer.'),

  // TYPE gauge
  // HELP Maximum timestamp of the head block.
  tsdb_head_max_time_seconds: metric('prometheus_tsdb_head_max_time_seconds', 'GAUGE', 'Maximum timestamp of the head block.'),

  // TYPE gauge
  // HELP Minimum time bound of the head block. The unit is decided by the library consumer.
  tsdb_head_min_time: metric('prometheus_tsdb_head_min_time', 'GAUGE', 'Minimum time bound of the head block. The unit is decided by the library consumer.'),

  // TYPE gauge
  // HELP Minimum time bound of the head block.
  tsdb_head_min_time_seconds: metric('prometheus_tsdb_head_min_time_seconds', 'GAUGE', 'Minimum time bound of the head block.'),

  // TYPE counter
  // HELP Total number of appended out of order samples.
  tsdb_head_out_of_order_samples_appended_total: metric('prometheus_tsdb_head_out_of_order_samples_appended_total', 'COUNTER', 'Total number of appended out of order samples.'),

  // TYPE counter
  // HELP Total number of appended samples.
  tsdb_head_samples_appended_total: metric('prometheus_tsdb_head_samples_appended_total', 'COUNTER', 'Total number of appended samples.'),

  // TYPE gauge
  // HELP Total number of series in the head block.
  tsdb_head_series: metric('prometheus_tsdb_head_series', 'GAUGE', 'Total number of series in the head block.'),

  // TYPE counter
  // HELP Total number of series created in the head
  tsdb_head_series_created_total: metric('prometheus_tsdb_head_series_created_total', 'COUNTER', 'Total number of series created in the head'),

  // TYPE counter
  // HELP Total number of requests for series that were not found.
  tsdb_head_series_not_found_total: metric('prometheus_tsdb_head_series_not_found_total', 'COUNTER', 'Total number of requests for series that were not found.'),

  // TYPE counter
  // HELP Total number of series removed in the head
  tsdb_head_series_removed_total: metric('prometheus_tsdb_head_series_removed_total', 'COUNTER', 'Total number of series removed in the head'),

  // TYPE counter
  // HELP Total number of head truncations that failed.
  tsdb_head_truncations_failed_total: metric('prometheus_tsdb_head_truncations_failed_total', 'COUNTER', 'Total number of head truncations that failed.'),

  // TYPE counter
  // HELP Total number of head truncations attempted.
  tsdb_head_truncations_total: metric('prometheus_tsdb_head_truncations_total', 'COUNTER', 'Total number of head truncations attempted.'),

  // TYPE gauge
  // HELP The highest TSDB append ID that has been given out.
  tsdb_isolation_high_watermark: metric('prometheus_tsdb_isolation_high_watermark', 'GAUGE', 'The highest TSDB append ID that has been given out.'),

  // TYPE gauge
  // HELP The lowest TSDB append ID that is still referenced.
  tsdb_isolation_low_watermark: metric('prometheus_tsdb_isolation_low_watermark', 'GAUGE', 'The lowest TSDB append ID that is still referenced.'),

  // TYPE gauge
  // HELP Lowest timestamp value stored in the database. The unit is decided by the library consumer.
  tsdb_lowest_timestamp: metric('prometheus_tsdb_lowest_timestamp', 'GAUGE', 'Lowest timestamp value stored in the database. The unit is decided by the library consumer.'),

  // TYPE gauge
  // HELP Lowest timestamp value stored in the database.
  tsdb_lowest_timestamp_seconds: metric('prometheus_tsdb_lowest_timestamp_seconds', 'GAUGE', 'Lowest timestamp value stored in the database.'),

  // TYPE counter
  // HELP Total number of memory-mapped chunk corruptions.
  tsdb_mmap_chunk_corruptions_total: metric('prometheus_tsdb_mmap_chunk_corruptions_total', 'COUNTER', 'Total number of memory-mapped chunk corruptions.'),

  // TYPE counter
  // HELP Total number of chunks that were memory-mapped.
  tsdb_mmap_chunks_total: metric('prometheus_tsdb_mmap_chunks_total', 'COUNTER', 'Total number of chunks that were memory-mapped.'),

  // TYPE counter
  // HELP Total number of out of bound samples ingestion failed attempts with out of order support disabled.
  tsdb_out_of_bound_samples_total: metric('prometheus_tsdb_out_of_bound_samples_total', 'COUNTER', 'Total number of out of bound samples ingestion failed attempts with out of order support disabled.'),

  // TYPE counter
  // HELP Total number of out of order samples ingestion failed attempts due to out of order being disabled.
  tsdb_out_of_order_samples_total: metric('prometheus_tsdb_out_of_order_samples_total', 'COUNTER', 'Total number of out of order samples ingestion failed attempts due to out of order being disabled.'),

  // TYPE counter
  // HELP Number of times the database failed to reloadBlocks block data from disk.
  tsdb_reloads_failures_total: metric('prometheus_tsdb_reloads_failures_total', 'COUNTER', 'Number of times the database failed to reloadBlocks block data from disk.'),

  // TYPE counter
  // HELP Number of times the database reloaded block data from disk.
  tsdb_reloads_total: metric('prometheus_tsdb_reloads_total', 'COUNTER', 'Number of times the database reloaded block data from disk.'),

  // TYPE gauge
  // HELP Max number of bytes to be retained in the tsdb blocks, configured 0 means disabled
  tsdb_retention_limit_bytes: metric('prometheus_tsdb_retention_limit_bytes', 'GAUGE', 'Max number of bytes to be retained in the tsdb blocks, configured 0 means disabled'),

  // TYPE gauge
  // HELP How long to retain samples in storage.
  tsdb_retention_limit_seconds: metric('prometheus_tsdb_retention_limit_seconds', 'GAUGE', 'How long to retain samples in storage.'),

  // TYPE counter
  // HELP The number of times that blocks were deleted because the maximum number of bytes was exceeded.
  tsdb_size_retentions_total: metric('prometheus_tsdb_size_retentions_total', 'COUNTER', 'The number of times that blocks were deleted because the maximum number of bytes was exceeded.'),

  // TYPE counter
  // HELP Total number snapshot replays that failed.
  tsdb_snapshot_replay_error_total: metric('prometheus_tsdb_snapshot_replay_error_total', 'COUNTER', 'Total number snapshot replays that failed.'),

  // TYPE gauge
  // HELP The number of bytes that are currently used for local storage by all blocks.
  tsdb_storage_blocks_bytes: metric('prometheus_tsdb_storage_blocks_bytes', 'GAUGE', 'The number of bytes that are currently used for local storage by all blocks.'),

  // TYPE gauge
  // HELP Size of symbol table in memory for loaded blocks
  tsdb_symbol_table_size_bytes: metric('prometheus_tsdb_symbol_table_size_bytes', 'GAUGE', 'Size of symbol table in memory for loaded blocks'),

  // TYPE counter
  // HELP The number of times that blocks were deleted because the maximum time limit was exceeded.
  tsdb_time_retentions_total: metric('prometheus_tsdb_time_retentions_total', 'COUNTER', 'The number of times that blocks were deleted because the maximum time limit was exceeded.'),

  // TYPE histogram
  // HELP The time taken to recompact blocks to remove tombstones.
  tsdb_tombstone_cleanup_seconds: metric('prometheus_tsdb_tombstone_cleanup_seconds', 'HISTOGRAM', 'The time taken to recompact blocks to remove tombstones.'),

  // TYPE counter
  // HELP Total number of out of order samples ingestion failed attempts with out of support enabled, but sample outside of time window.
  tsdb_too_old_samples_total: metric('prometheus_tsdb_too_old_samples_total', 'COUNTER', 'Total number of out of order samples ingestion failed attempts with out of support enabled, but sample outside of time window.'),

  // TYPE counter
  // HELP Total number of compactions done on overlapping blocks.
  tsdb_vertical_compactions_total: metric('prometheus_tsdb_vertical_compactions_total', 'COUNTER', 'Total number of compactions done on overlapping blocks.'),

  // TYPE counter
  // HELP Total number of completed pages.
  tsdb_wal_completed_pages_total: metric('prometheus_tsdb_wal_completed_pages_total', 'COUNTER', 'Total number of completed pages.'),

  // TYPE counter
  // HELP Total number of WAL corruptions.
  tsdb_wal_corruptions_total: metric('prometheus_tsdb_wal_corruptions_total', 'COUNTER', 'Total number of WAL corruptions.'),

  // TYPE summary
  // HELP Duration of write log fsync.
  tsdb_wal_fsync_duration_seconds: metric('prometheus_tsdb_wal_fsync_duration_seconds', 'SUMMARY', 'Duration of write log fsync.'),

  // TYPE counter
  // HELP Total number of page flushes.
  tsdb_wal_page_flushes_total: metric('prometheus_tsdb_wal_page_flushes_total', 'COUNTER', 'Total number of page flushes.'),

  // TYPE gauge
  // HELP Write log segment index that TSDB is currently writing to.
  tsdb_wal_segment_current: metric('prometheus_tsdb_wal_segment_current', 'GAUGE', 'Write log segment index that TSDB is currently writing to.'),

  // TYPE gauge
  // HELP Size of the write log directory.
  tsdb_wal_storage_size_bytes: metric('prometheus_tsdb_wal_storage_size_bytes', 'GAUGE', 'Size of the write log directory.'),

  // TYPE summary
  // HELP Duration of WAL truncation.
  tsdb_wal_truncate_duration_seconds: metric('prometheus_tsdb_wal_truncate_duration_seconds', 'SUMMARY', 'Duration of WAL truncation.'),

  // TYPE counter
  // HELP Total number of write log truncations that failed.
  tsdb_wal_truncations_failed_total: metric('prometheus_tsdb_wal_truncations_failed_total', 'COUNTER', 'Total number of write log truncations that failed.'),

  // TYPE counter
  // HELP Total number of write log truncations attempted.
  tsdb_wal_truncations_total: metric('prometheus_tsdb_wal_truncations_total', 'COUNTER', 'Total number of write log truncations attempted.'),

  // TYPE counter
  // HELP Total number of write log writes that failed.
  tsdb_wal_writes_failed_total: metric('prometheus_tsdb_wal_writes_failed_total', 'COUNTER', 'Total number of write log writes that failed.'),

  // TYPE counter
  // HELP Total number of errors that occurred while sending federation responses.
  web_federation_errors_total: metric('prometheus_web_federation_errors_total', 'COUNTER', 'Total number of errors that occurred while sending federation responses.'),

  // TYPE counter
  // HELP Total number of warnings that occurred while sending federation responses.
  web_federation_warnings_total: metric('prometheus_web_federation_warnings_total', 'COUNTER', 'Total number of warnings that occurred while sending federation responses.'),
};

prometheus
