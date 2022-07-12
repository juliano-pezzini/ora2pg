-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW controle_v (nr_pendencia, nr_sequencia, ds_pendencia) AS select	nr_pendencia,
	nr_sequencia,
	ds_pendencia
FROM	controle_acomp_risco_v

union

select	nr_pendencia,
	nr_sequencia,
	ds_pendencia
from	controle_status_report_v;
