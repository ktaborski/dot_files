#!/usr/bin/env bash
exec kc get po --field-selector=status.phase=Pending -A $@
