-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_avf_questoes_sem_nota (nr_seq_avf_resultado_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	bigint;


BEGIN

select	count(1)
into STRICT	vl_retorno_w
from	avf_resultado a,
	avf_resultado_item b
where	b.nr_seq_resultado = a.nr_sequencia
and	(b.nr_seq_pergunta IS NOT NULL AND b.nr_seq_pergunta::text <> '')
and	(substr(obter_dados_avf_tipo_nota_item(b.nr_seq_nota_item,CASE WHEN obter_valor_param_usuario(6,73,obter_perfil_ativo,obter_usuario_ativo,obter_estabelecimento_ativo)='N' THEN 'N'  ELSE 'P' END ,b.nr_seq_pergunta,b.nr_seq_resultado),1,10))::coalesce(numeric::text, '') = ''
and	a.nr_sequencia = nr_seq_avf_resultado_p;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_avf_questoes_sem_nota (nr_seq_avf_resultado_p bigint) FROM PUBLIC;
