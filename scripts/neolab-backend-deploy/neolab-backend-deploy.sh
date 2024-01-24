#!/bin/bash

echo "neolab:" > $script_output_file_path
echo "  apiroot: $neolab_apiroot" >> $script_output_file_path
echo "  rooturl: $neolab_rooturl" >> $script_output_file_path
echo "  loglevel: $neolab_loglevel" >> $script_output_file_path
echo "  emailsender: $neolab_emailsender" >> $script_output_file_path 
echo "  secret: $neolab_secret" >> $script_output_file_path
echo "  upssync_queue_name: $neolab_upssync_queue_name" >> $script_output_file_path
echo "  email_backend: $neolab_email_backend" >> $script_output_file_path
echo '  smtp_email_host: ""' >> $script_output_file_path
echo '  smtp_email_host_user: ""' >> $script_output_file_path
echo '  smtp_email_host_password: ""' >> $script_output_file_path
echo '  smtp_email_port: ""' >> $script_output_file_path
echo "  api_allowed_ips: $neolab_api_allowed_ips" >> $script_output_file_path
echo "  es_endpoint: $neolab_es_endpoint" >> $script_output_file_path 
echo "  es_index_prefix: $neolab_es_index_prefix" >> $script_output_file_path
echo "  pause_emailsender: $neolab_pause_emailsender" >> $script_output_file_path
echo "  backend_replicas: $neolab_backend_replicas" >> $script_output_file_path
echo "  email_period_seconds: $neolab_email_period_seconds" >> $script_output_file_path
echo "  sync_attachments_high_limit_minutes: $neolab_sync_attachments_high_limit_minutes" >> $script_output_file_path
echo "  sync_attachments_low_limit_minutes: $neolab_sync_attachments_low_limit_minutes" >> $script_output_file_path
echo "  es_message_queue_url: $neolab_es_message_queue_url" >> $script_output_file_path 
echo "  es_message_queue_name: $neolab_es_message_queue_name" >> $script_output_file_path
echo "  celeryworker_replicas: $neolab_celeryworker_replicas" >> $script_output_file_path
echo "  celery_worker_concurrency: $neolab_celery_worker_concurrency" >> $script_output_file_path
echo "  wicked_quick_deadline_hour: $neolab_wicked_quick_deadline_hour" >> $script_output_file_path
echo "  certificate_arn: $neolab_certificate_arn" >> $script_output_file_path 
echo "  email_engine: $neolab_email_engine" >> $script_output_file_path
echo "  support_team_email: $neolab_support_team_email" >> $script_output_file_path
echo "  aws:" >> $script_output_file_path
echo "    region: $neolab_aws_region" >> $script_output_file_path
echo "    pinpoint_app_id: $neolab_aws_pinpoint_app_id" >> $script_output_file_path 
echo "    ses:" >> $script_output_file_path
echo "      region: $neolab_aws_ses_region" >> $script_output_file_path
echo "    cloudfront:" >> $script_output_file_path
echo "      keyid: $neolab_aws_cloudfront_keyid" >> $script_output_file_path
echo "      keyfile: $neolab_aws_cloudfront_keyfile" >> $script_output_file_path
echo "  ups:" >> $script_output_file_path
echo "    username: $neolab_ups_username" >> $script_output_file_path
echo "    password: $neolab_ups_password" >> $script_output_file_path
echo "    access_license_number: $neolab_ups_access_license_number" >> $script_output_file_path
echo "    account_number: $neolab_ups_account_number" >> $script_output_file_path 
echo "    shipping_label_url: $neolab_ups_shipping_label_url" >> $script_output_file_path 
echo "    url_tnt: $neolab_ups_url_tnt" >> $script_output_file_path 
echo "    client_id: $neolab_ups_client_id" >> $script_output_file_path 
echo "    client_secret: $neolab_ups_client_secret" >> $script_output_file_path 
echo "    api_base_url: $neolab_ups_api_base_url" >> $script_output_file_path
echo "  easyrx:" >> $script_output_file_path
echo "    user: $neolab_easyrx_user" >> $script_output_file_path
echo "    password: $neolab_easyrx_password" >> $script_output_file_path 
echo "    url_open_cases: $neolab_easyrx_url_open_cases" >> $script_output_file_path 
echo "    url_get_case: $neolab_easyrx_url_get_case" >> $script_output_file_path 
echo "    url_get_file: $neolab_easyrx_url_get_file" >> $script_output_file_path
echo "    url_update_case: $neolab_easyrx_url_update_case" >> $script_output_file_path
echo "  admin:" >> $script_output_file_path
echo "    name: $neolab_admin_name" >> $script_output_file_path
echo "    email: $neolab_admin_email" >> $script_output_file_path
echo "    password: $neolab_admin_password" >> $script_output_file_path
echo "  db:" >> $script_output_file_path
echo "    host: $neolab_db_host" >> $script_output_file_path
echo "    user: $neolab_db_user" >> $script_output_file_path
echo "    name: $neolab_db_name" >> $script_output_file_path
echo "    password: $neolab_db_password" >> $script_output_file_path
echo "  s3:" >> $script_output_file_path
echo "    app: $neolab_s3_app" >> $script_output_file_path
echo "    tmp: $neolab_s3_tmp" >> $script_output_file_path
echo "    web: $neolab_s3_web" >> $script_output_file_path
echo "  cache:" >> $script_output_file_path
echo "    urls: $neolab_cache_urls" >> $script_output_file_path
echo "  zebra:" >> $script_output_file_path
echo "    printer_sn: $neolab_zebra_printer_sn" >> $script_output_file_path
echo "    api_key: $neolab_zebra_api_key" >> $script_output_file_path
echo "    tenant: $neolab_zebra_tenant" >> $script_output_file_path
echo "    send_to_s3_instead: $neolab_zebra_send_to_s3_instead" >> $script_output_file_path
echo "  quickbooks:" >> $script_output_file_path
echo "    client_id: $neolab_quickbooks_client_id" >> $script_output_file_path
echo "    client_secret: $neolab_quickbooks_client_secret" >> $script_output_file_path
echo "    company_id: $neolab_quickbooks_company_id" >> $script_output_file_path
echo "    base_url: $neolab_quickbooks_base_url" >> $script_output_file_path
echo "    sandbox: $neolab_quickbooks_sandbox" >> $script_output_file_path
echo "    account_id: $neolab_quickbooks_account_id" >> $script_output_file_path
echo "    account_name: $neolab_quickbooks_account_name" >> $script_output_file_path
echo "    expense_account_id: $neolab_quickbooks_expense_account_id" >> $script_output_file_path
echo "    is_allowed: $neolab_quickbooks_is_allowed" >> $script_output_file_path
echo "  resources:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 1024M" >> $script_output_file_path
echo "      cpu: 1" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 64M" >> $script_output_file_path
echo "      cpu: 50m" >> $script_output_file_path
echo "  resources_backend:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 512M" >> $script_output_file_path
echo "      cpu: 1100m" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 300M" >> $script_output_file_path
echo "      cpu: 800m" >> $script_output_file_path
echo "  resources_celeryworker:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 1024M" >> $script_output_file_path
echo "      cpu: 1" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 350M" >> $script_output_file_path
echo "      cpu: 700m" >> $script_output_file_path
echo "  resources_completecases:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 400M" >> $script_output_file_path
echo "      cpu: 1" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 300M" >> $script_output_file_path
echo "      cpu: 700m" >> $script_output_file_path
echo "  resources_updateqbotoken:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 150M" >> $script_output_file_path
echo "      cpu: 800m" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 100M" >> $script_output_file_path
echo "      cpu: 500m" >> $script_output_file_path
echo "  resources_common_max:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 300M" >> $script_output_file_path
echo "      cpu: 200m" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 150M" >> $script_output_file_path
echo "      cpu: 100m" >> $script_output_file_path
echo "  resources_common_min:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 200M" >> $script_output_file_path
echo "      cpu: 100m" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 70M" >> $script_output_file_path
echo "      cpu: 70m" >> $script_output_file_path
echo "  resources_uploadqbo:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 250M" >> $script_output_file_path
echo "      cpu: 350m" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
echo "      mem: 150M" >> $script_output_file_path
echo "      cpu: 200m" >> $script_output_file_path
echo "  resources_update_es_indexes_for_finished_cases:" >> $script_output_file_path
echo "    limits:" >> $script_output_file_path
echo "      mem: 300M" >> $script_output_file_path
echo "      cpu: 1" >> $script_output_file_path
echo "    requests:" >> $script_output_file_path
