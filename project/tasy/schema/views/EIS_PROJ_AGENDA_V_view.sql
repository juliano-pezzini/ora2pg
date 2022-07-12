-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_proj_agenda_v (cd_consultor, nm_consultor, dt_referencia, ie_status, qt_dias, ie_periodo) AS select	cd_consultor,
	substr(obter_nome_pf(cd_consultor),1,255) nm_consultor, 
	dt_agenda dt_referencia, 
	ie_status, 
	count(*) qt_dias, 
	'M' ie_periodo 
FROM	proj_agenda 
where 1 = 1 
group by cd_consultor, 
	dt_agenda, 
	ie_status;
