-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_status_orc_os ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(500);
qt_registro_w			bigint;
dt_geracao_cobranca_w		timestamp;
dt_reprovacao_w			timestamp;
dt_aprovacao_w			timestamp;
nr_seq_motivo_nao_cobra_w	bigint;


BEGIN

if (nr_sequencia_p > 0) then
	select	count(*)
	into STRICT	qt_registro_w
	from	man_ordem_servico_orc a
	where	a.nr_seq_ordem = nr_sequencia_p;

	if (qt_registro_w > 0) then
		begin
		select	a.dt_geracao_cobranca,
			a.dt_reprovacao,
			a.dt_aprovacao,
			a.nr_seq_motivo_nao_cobra
		into STRICT	dt_geracao_cobranca_w,
			dt_reprovacao_w,
			dt_aprovacao_w,
			nr_seq_motivo_nao_cobra_w
		from	man_ordem_servico_orc a
		where	a.nr_sequencia = (	SELECT	max(nr_sequencia)
						from	man_ordem_servico_orc a
						where	a.nr_seq_ordem = nr_sequencia_p
						);

		if (dt_geracao_cobranca_w IS NOT NULL AND dt_geracao_cobranca_w::text <> '') then
			ds_retorno_w := obter_desc_expressao(313037);
		elsif ((dt_reprovacao_w IS NOT NULL AND dt_reprovacao_w::text <> '') or (nr_seq_motivo_nao_cobra_w IS NOT NULL AND nr_seq_motivo_nao_cobra_w::text <> '')) then
			ds_retorno_w := obter_desc_expressao(322155);
		elsif (dt_aprovacao_w IS NOT NULL AND dt_aprovacao_w::text <> '') then
			ds_retorno_w := obter_desc_expressao(283709);
		else
			ds_retorno_w := obter_desc_expressao(308445);
		end if;
		end;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_status_orc_os ( nr_sequencia_p bigint) FROM PUBLIC;
