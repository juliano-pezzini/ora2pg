-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inapto_sinal_vital ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


vl_retorno_w		varchar(255);


BEGIN

select	max(substr(obter_descricao_padrao('INAPTO_DOR','DS_MOTIVO',NR_SEQ_INAPTO_DOR),1,100))
into STRICT	vl_retorno_w
from	atendimento_sinal_vital
where	nr_sequencia = (SELECT	coalesce(max(nr_sequencia),-1)
			from	atendimento_sinal_vital
			where	(nr_seq_inapto_dor IS NOT NULL AND nr_seq_inapto_dor::text <> '')
			and	nr_atendimento	= nr_atendimento_p
			and	ie_situacao = 'A'
			and	coalesce(IE_RN,'N')	= 'N');

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inapto_sinal_vital ( nr_atendimento_p bigint) FROM PUBLIC;

