input {
    redis {
        host        => <%= @redis1_host %>
        type        => "redis.input"
        data_type   => "list"
        key         => "logstash"
        batch_count => <%= @logstash_redis_batch_count %>
        threads     => <%= @logstash_redis_threads %>
    }
    redis {
        host        => <%= @redis2_host %>
        type        => "redis.input"
        data_type   => "list"
        batch_count => <%= @logstash_redis_batch_count %>
        threads     => <%= @logstash_redis_threads %>
    }
}
