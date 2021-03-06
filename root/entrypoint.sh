#!/bin/sh

if [ "$1" = "wallabag" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local
    exec s6-svscan /etc/s6/
fi
if [ "$1" = "import" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local --skip-tags=firstrun
    cd /var/www/wallabag/
    exec su -c "bin/console wallabag:import:redis-worker -e=prod $2 -vv" -s /bin/sh nobody
fi
if [ "$1" = "migrate" ];then
    ansible-playbook -i /etc/ansible/hosts /etc/ansible/entrypoint.yml -c local
    cd /var/www/wallabag/
    exec su -c "bin/console doctrine:migrations:migrate --env=prod --no-interaction" -s /bin/sh nobody
fi

exec "$@"
