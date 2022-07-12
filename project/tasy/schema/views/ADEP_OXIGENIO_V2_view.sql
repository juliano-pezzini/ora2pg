-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW adep_oxigenio_v2 (nr_atendimento, nm_usuario, nr_seq_oxigenio, ie_respiracao, ds_respiracao, cd_mod_vent, ds_mod_vent, ie_disp_resp_esp, ds_disp_resp_esp, qt_fluxo_oxigenio, dt_monitorizacao, cd_pessoa_evento, nm_pessoa_evento, dt_final_monit, qt_tempo_oxigenio) AS select	nr_atendimento,
	nm_usuario, 
	nr_sequencia nr_seq_oxigenio, 
	ie_respiracao, 
	substr(obter_valor_dominio(1299,ie_respiracao),1,240) ds_respiracao, 
	cd_mod_vent, 
	substr(obter_desc_mod_ventilatoria(cd_mod_vent),1,240) ds_mod_vent, 
	ie_disp_resp_esp, 
	substr(obter_valor_dominio(1612,ie_disp_resp_esp),1,240) ds_disp_resp_esp, 
	qt_fluxo_oxigenio, 
	dt_monitorizacao, 
	cd_pessoa_fisica cd_pessoa_evento, 
	substr(obter_nome_pf(cd_pessoa_fisica),1,60) nm_pessoa_evento, 
	dt_final_monit, 
	qt_tempo_oxigenio 
FROM	w_adep_oxigenio;

