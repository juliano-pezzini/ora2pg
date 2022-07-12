-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_triagem ( nr_seq_fila_senha_p bigint) RETURNS bigint AS $body$
DECLARE


nr_classif_w		triagem_classif_risco.nr_seq_prioridade%type	:=	999;
nr_seq_classif_w	triagem_pronto_atend.nr_seq_classif%type;



BEGIN


select	max(NR_SEQ_CLASSIF)
into STRICT	nr_seq_classif_w
from	TRIAGEM_PRONTO_ATEND
where	nr_seq_fila_senha	=	nr_seq_fila_senha_p;

if (nr_seq_classif_w > 0) then
	begin
	
	select	max(NR_SEQ_PRIORIDADE)
	into STRICT	nr_classif_w
	from	TRIAGEM_CLASSIF_RISCO
	where	nr_sequencia = nr_seq_classif_w
	and	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento
	and	ie_situacao = 'A';
				
	end;
end if;


return	nr_classif_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_triagem ( nr_seq_fila_senha_p bigint) FROM PUBLIC;

