-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_dt_conclusao_proj ( nr_sequencia_p bigint, nr_seq_estagio_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w				timestamp;
ie_tipo_estagio_w			varchar(15);
nr_seq_estagio_w			bigint;
nr_seq_movto_estagio_w			bigint;


BEGIN

nr_seq_estagio_w	:= nr_seq_estagio_p;

if (coalesce(nr_sequencia_p,0) <> 0) then
	begin

	if (coalesce(nr_seq_estagio_p::text, '') = '') then
		select	max(nr_seq_estagio)
		into STRICT	nr_seq_estagio_w
		from	gpi_projeto
		where	nr_sequencia	= nr_sequencia_p;
	end if;

	if (nr_seq_estagio_w IS NOT NULL AND nr_seq_estagio_w::text <> '') then
		begin
		select	coalesce(max(b.ie_tipo_estagio),'')
		into STRICT	ie_tipo_estagio_w
		from	gpi_estagio b
		where	b.nr_sequencia	= nr_seq_estagio_w;

		/*Estágio de conclusão/encerramento */

		if (ie_tipo_estagio_w IS NOT NULL AND ie_tipo_estagio_w::text <> '') and (ie_tipo_estagio_w = 'C') then
			begin
			select	max(dt_atualizacao)
			into STRICT	dt_retorno_w
			from	gpi_log_estagio a
			where	nr_seq_projeto	= nr_sequencia_p
			and	nr_seq_estagio	= nr_seq_estagio_w;
			end;
		end if;
		end;
	end if;
	end;
end if;

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpi_obter_dt_conclusao_proj ( nr_sequencia_p bigint, nr_seq_estagio_p bigint) FROM PUBLIC;
