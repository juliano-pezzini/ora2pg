-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sip_obter_cbo_anexo_iii ( nr_seq_procedimento_p bigint, ie_tipo_despesa_p text) RETURNS bigint AS $body$
DECLARE


/* IE_TIPO_DESPESA_P
*/
nr_seq_retorno_w	bigint;
cd_medico_w		varchar(10);


BEGIN

select	coalesce(max(nr_seq_cbo_saude),'')
into STRICT	nr_seq_retorno_w
from	pls_proc_participante
where	nr_seq_conta_proc = nr_seq_procedimento_p;

return	nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sip_obter_cbo_anexo_iii ( nr_seq_procedimento_p bigint, ie_tipo_despesa_p text) FROM PUBLIC;

