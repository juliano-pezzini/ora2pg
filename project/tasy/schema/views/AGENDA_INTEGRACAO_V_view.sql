-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW agenda_integracao_v (cd_agenda, ds_agenda, cd_tipo_agenda, ds_tipo_agenda, cd_profissional, nm_profissional) AS select a.cd_agenda,
	       a.ds_agenda,
	       cd_tipo_agenda,
	       substr(obter_valor_dominio(34,a.cd_tipo_agenda),1,255) ds_tipo_agenda,
	       a.cd_pessoa_fisica cd_profissional,
	       b.nm_pessoa_fisica nm_profissional
	FROM agenda a
LEFT OUTER JOIN pessoa_fisica b ON (a.cd_pessoa_fisica = b.cd_pessoa_fisica);

