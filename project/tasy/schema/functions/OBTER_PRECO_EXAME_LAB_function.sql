-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_preco_exame_lab (NR_SEQ_EXAME_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, ie_tipo_convenio_p bigint, IE_TIPO_ATENDIMENTO_P bigint, CD_ESTABELECIMENTO_P bigint, ie_opcao_p bigint) RETURNS bigint AS $body$
DECLARE

 
/* 
0 - Vl procedimento 
1 - Vl ch 
*/
 
 
ie_tipo_convenio_w	integer;
vl_retorno_w		double precision;
CD_SETOR_w		bigint;
CD_PROCEDIMENTO_w	bigint;
IE_ORIGEM_PROCED_w	bigint;
DS_ERRO_w		varchar(254);
nr_seq_proc_interno_aux_w	bigint;


BEGIN 
 
select	coalesce(max(ie_tipo_convenio),0) 
into STRICT	ie_tipo_convenio_w 
from	convenio 
where	cd_convenio	= cd_convenio_p;
 
SELECT * FROM OBTER_EXAME_LAB_CONVENIO( 
		NR_SEQ_EXAME_P, CD_CONVENIO_P, CD_CATEGORIA_P, ie_tipo_convenio_w, CD_ESTABELECIMENTO_P, coalesce(ie_tipo_convenio_p, ie_tipo_convenio_w), null, null, null, CD_SETOR_w, CD_PROCEDIMENTO_w, IE_ORIGEM_PROCED_w, DS_ERRO_w, nr_seq_proc_interno_aux_w) INTO STRICT CD_SETOR_w, CD_PROCEDIMENTO_w, IE_ORIGEM_PROCED_w, DS_ERRO_w, nr_seq_proc_interno_aux_w;
 
vl_retorno_w	:= 0;
 
if (coalesce(ds_erro_w::text, '') = '') then 
	if (ie_opcao_p = 0) then 
 
		vl_retorno_w	:= Obter_Valor_Lancto_Automatico(CD_ESTABELECIMENTO_P, 
					CD_PROCEDIMENTO_w, 
					IE_ORIGEM_PROCED_w, 
					CD_CONVENIO_P, 
					CD_CATEGORIA_P, 
					clock_timestamp(), 
					IE_TIPO_ATENDIMENTO_P, 
					NR_SEQ_EXAME_P);
 
	elsif (ie_opcao_p = 1) then 
		vl_retorno_w	:= Obter_CH_Lancto_Automatico(CD_ESTABELECIMENTO_P, 
					CD_PROCEDIMENTO_w, 
					IE_ORIGEM_PROCED_w, 
					CD_CONVENIO_P, 
					CD_CATEGORIA_P, 
					clock_timestamp(), 
					IE_TIPO_ATENDIMENTO_P, 
					NR_SEQ_EXAME_P);
 
	end if;
end if;
 
return	vl_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_preco_exame_lab (NR_SEQ_EXAME_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, ie_tipo_convenio_p bigint, IE_TIPO_ATENDIMENTO_P bigint, CD_ESTABELECIMENTO_P bigint, ie_opcao_p bigint) FROM PUBLIC;

