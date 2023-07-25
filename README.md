# ComputeStacks PHP Images

We are currently maintaining two variants: OpenLiteSpeed and nginx with PHP-FPM. 

## Submitting Issues

If you encounter a technical issue, you may [open an issue](https://github.com/ComputeStacks/cs-docker-php/issues). However, for questions or how-to's, please [post on our forum](https://forum.computestacks.com).


## Migrating from OpenLiteSpeed to nginx
```
  sed -i 's/\/usr\/local\/lsws\/lsphp.*\/bin\/php/\/usr\/bin\/php/g' /var/www/crontab
```


## Contributing

Contributions are welcome! Before you submit a pull request, feel free to [post on our forum](https://forum.computestacks.com) your idea and we can have a discussion.

