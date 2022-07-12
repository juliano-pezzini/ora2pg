-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_envia_elegibilidade (cd_estabelecimento_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    varchar(10);
count_w         bigint := 0;
nr_seq_evento_sistema_w	intpd_eventos_sistema.nr_sequencia%type;


BEGIN

ds_retorno_w := 'N';

select	count(*)
into STRICT	count_w
from	tiss_convenio
where	cd_estabelecimento		= cd_estabelecimento_p
and		cd_convenio				= cd_convenio_p
and		ie_tipo_tiss			= '13'; --Verifica Elegibilidade;
if (count_w > 0) then
	ds_retorno_w := 'S';
else
	begin

	select	max(b.nr_sequencia)
	into STRICT	nr_seq_evento_sistema_w
	from	intpd_eventos a,
			intpd_eventos_sistema b
	where	a.nr_sequencia = b.nr_seq_evento
	and		a.ie_evento = '213'
	and		a.ie_situacao = 'A'
	and		b.ie_situacao = 'A'
	order by coalesce(b.nr_seq_ordem_exec,0),
			b.nr_sequencia;

	if (nr_seq_evento_sistema_w > 0) then
		begin
		select	max(coalesce(ie_integrar,'S'))
		into STRICT	ds_retorno_w
		from	intpd_eventos_sistema_rest
		where	nr_seq_evento_sistema = nr_seq_evento_sistema_w
		and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
		and	coalesce(cd_convenio,coalesce(cd_convenio_p,0)) = coalesce(cd_convenio_p,0)
		order by
			coalesce(cd_estabelecimento, 0),
			coalesce(cd_convenio, 0);
		end;
	end if;
	end;
end if;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_envia_elegibilidade (cd_estabelecimento_p bigint, cd_convenio_p bigint) FROM PUBLIC;
