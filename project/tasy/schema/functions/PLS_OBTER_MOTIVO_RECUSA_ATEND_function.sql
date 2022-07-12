-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_motivo_recusa_atend (nr_seq_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_mensagem_w		varchar(4000)	:= null;
nr_seq_atend_hist_w	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_atend_hist_w
from	pls_atendimento_historico
where	nr_seq_atendimento = nr_seq_atendimento_p;

/* Francisco - OS798738, comentei pois não é possível fazer esse tratamento com LONG e esse processo não é mais usado
select	substr(ds_historico,instr(ds_historico ,'.')+1,length(ds_historico))
into	ds_mensagem_w
from	pls_atendimento_historico
where	nr_sequencia =  nr_seq_atend_hist_w;
*/
return	ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_motivo_recusa_atend (nr_seq_atendimento_p bigint) FROM PUBLIC;
