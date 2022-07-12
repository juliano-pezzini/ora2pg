-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cor_triagem_prioridade (nr_seq_fila_senha_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_triagem_prioridade_w	triagem_pronto_atend.nr_seq_triagem_prioridade%type;
ds_cor_w			triagem_classif_prioridade.ds_cor%type;

BEGIN

select	max(nr_seq_triagem_prioridade)
into STRICT	nr_seq_triagem_prioridade_w
from	triagem_pronto_atend
where	nr_seq_fila_senha = nr_seq_fila_senha_p;

if (nr_seq_triagem_prioridade_w > 0) then
	begin	
		select	max(ds_cor)
		into STRICT	ds_cor_w
		from	triagem_classif_prioridade
		where	nr_sequencia = nr_seq_triagem_prioridade_w
		and	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento
		and	ie_situacao = 'A';
	end;
end if;

return	ds_cor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cor_triagem_prioridade (nr_seq_fila_senha_p bigint) FROM PUBLIC;
