-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW setor_atend_integracao_v (cd_setor_atendimento, ds_setor_atendimento, nm_usuario_banco, cd_estabelecimento_base) AS select  	cd_setor_atendimento,
	ds_setor_atendimento,
	nm_usuario_banco,
	cd_estabelecimento_base
FROM 	setor_atendimento;

