# ComputeStacks PHP Images

[![PHP 8 nginx](https://github.com/ComputeStacks/cs-docker-php/actions/workflows/php8-nginx.yml/badge.svg?branch=main)](https://github.com/ComputeStacks/cs-docker-php/actions/workflows/php8-nginx.yml)

Our OpenLiteSpeed images are deprecated and will only be receiving security updates. Please migrate to our nginx images.

## Submitting Issues

If you encounter a technical issue, you may [open an issue](https://github.com/ComputeStacks/cs-docker-php/issues). However, for questions or how-to's, please [post on our forum](https://forum.computestacks.com).


## Migrating from OpenLiteSpeed to nginx
```
  sed -i 's/\/usr\/local\/lsws\/lsphp.*\/bin\/php/\/usr\/bin\/php/g' /var/www/crontab
```


## Contributing

Contributions are welcome! Before you submit a pull request, feel free to [post on our forum](https://forum.computestacks.com) your idea and we can have a discussion.

