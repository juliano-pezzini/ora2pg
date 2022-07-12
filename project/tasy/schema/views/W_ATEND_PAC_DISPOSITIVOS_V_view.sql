-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_atend_pac_dispositivos_v (dt_instalacao, nr_atendimento, nr_seq_dispositivo, ds_dispositivo, ie_sucesso, qt_sucesso, cd_setor_atendimento, ds_setor_atendimento, ds_unidade) AS select	distinct
		a.dt_instalacao, 
		a.nr_atendimento, 
		a.nr_seq_dispositivo, 
		substr(Obter_nome_dispositivo(a.nr_seq_dispositivo),1,255) ds_dispositivo, 
		coalesce(a.ie_sucesso,'S') ie_sucesso, 
		CASE WHEN coalesce(a.ie_sucesso,'S')='S' THEN  1  ELSE 0 END  qt_sucesso, 
		obter_unidade_atendimento(a.nr_atendimento,'A','CS') cd_setor_atendimento, 
		substr(obter_nome_setor(obter_unidade_atendimento(a.nr_atendimento,'A','CS')),1,255) ds_setor_atendimento, 
		substr(obter_unidade_atendimento(a.nr_atendimento,'A','U'),1,255) ds_unidade 
FROM	atend_pac_dispositivo a;

