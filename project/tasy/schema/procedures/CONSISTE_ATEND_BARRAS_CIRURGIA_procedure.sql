-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_atend_barras_cirurgia ( nr_prescricao_p bigint, nm_usuario_p text, ds_tipo_retorno_p INOUT text, ds_retorno_p INOUT text) AS $body$
DECLARE

 
ds_tipo_retorno_w	varchar(15)	:= 'P';
ds_retorno_w		varchar(2000) 	:= NULL;
ie_permitir_baixa_w	varchar(15);
ie_conta_fechada_w	varchar(15);
cd_perfil_w		integer;
cd_estabelecimento_w	smallint;
nr_atendimento_w	bigint;
nr_cirurgia_w		bigint;
cd_convenio_w		integer;
cd_categoria_w		bigint;


BEGIN 
/* 
ds_tipo_retorno_w 
A - Avisa e permite 
C - Avisa e bloqueia 
B - Não avisa e bloqueia 
*/
 
cd_perfil_w 		:= wheb_usuario_pck.get_cd_perfil;
cd_estabelecimento_w 	:= wheb_usuario_pck.get_cd_estabelecimento;
 
ie_permitir_baixa_w := obter_param_usuario(900, 77, cd_perfil_w, nm_usuario_p, cd_estabelecimento_w, ie_permitir_baixa_w);
 
/* Verifica se o atendimento possui a conta fechada */
 
SELECT	MAX(a.nr_atendimento), 
	MAX(b.nr_cirurgia), 
	MAX(b.cd_convenio), 
	MAX(b.cd_categoria) 
INTO STRICT	nr_atendimento_w, 
	nr_cirurgia_w, 
	cd_convenio_w, 
	cd_categoria_w 
FROM	prescr_medica a, 
	cirurgia b 
WHERE	a.nr_prescricao = b.nr_prescricao 
AND	a.nr_prescricao = nr_prescricao_p;
 
IF (ie_permitir_baixa_w <> 'S') THEN 
	SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END  
	INTO STRICT	ie_conta_fechada_w 
	FROM	atendimento_paciente 
	WHERE	nr_atendimento = nr_atendimento_w 
	AND	ie_fim_conta = 'F' 
	AND	(dt_fim_conta IS NOT NULL AND dt_fim_conta::text <> '');
 
	IF	(ie_permitir_baixa_w = 'A' AND ie_conta_fechada_w = 'S') THEN 
		ds_retorno_w		:= Wheb_mensagem_pck.get_texto(306317, null); -- A conta deste atendimento já está fechada! 
		ds_tipo_retorno_w	:= 'A';
	ELSIF	(ie_permitir_baixa_w = 'B' AND ie_conta_fechada_w = 'S') THEN 
		ds_retorno_w		:= Wheb_mensagem_pck.get_texto(306316, null); -- A conta deste atendimento já está fechada. Não é possível baixar esta prescrição na conta do paciente. 
		ds_tipo_retorno_w	:= 'C';
	ELSIF	(ie_permitir_baixa_w = 'N' AND ie_conta_fechada_w = 'S') THEN 
		ds_retorno_w		:= NULL;
		ds_tipo_retorno_w	:= 'B';
	END IF;
END IF;
 
ds_tipo_retorno_p 	:= ds_tipo_retorno_w;
ds_retorno_p		:= ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_atend_barras_cirurgia ( nr_prescricao_p bigint, nm_usuario_p text, ds_tipo_retorno_p INOUT text, ds_retorno_p INOUT text) FROM PUBLIC;

