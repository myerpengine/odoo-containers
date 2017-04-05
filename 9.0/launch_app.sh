#!/bin/bash
source /home/user/virtualenv/bin/activate
exec /home/user/odoo/odoo/openerp-server -c /home/user/odoo_config.ini -d odoo "$@"
