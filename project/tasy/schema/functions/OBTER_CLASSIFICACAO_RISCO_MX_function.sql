-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classificacao_risco_mx (nr_atendimento_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  varchar(1);
nr_seq_prioridade_w bigint;

C01 CURSOR FOR
 SELECT nr_seq_classif
 from triagem_pronto_atend
 where  nr_atendimento = nr_atendimento_p
 and nr_seq_classif = nr_seq_prioridade_w;


BEGIN

open C01;
loop
fetch C01 into
 nr_seq_prioridade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
 begin
 select ie_tipo_urgencia_nom
 into STRICT ds_retorno_w
 from triagem_classif_risco a
 where nr_sequencia = nr_seq_prioridade_w;

 end;
end loop;
close C01;

return coalesce(ds_retorno_w,'N');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classificacao_risco_mx (nr_atendimento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
