-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_precaucoes_paciente (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(4000);
ds_auxiliar_w cih_precaucao.ds_precaucao%type;
nr_seq_precaucao_atend_w bigint;
nr_seq_precaucao_w bigint;
nr_Seq_motivo_precaucao_w bigint;
nr_atendimento_w atendimento_paciente.nr_atendimento%type;

C02 CURSOR FOR
	SELECT nr_atendimento
	from atendimento_paciente
	where cd_pessoa_fisica = cd_pessoa_fisica_p
	and coalesce(dt_cancelamento::text, '') = ''
	order by dt_atualizacao_nrec desc;

C01 CURSOR FOR
	SELECT a.nr_sequencia
	from atendimento_precaucao a ,
	cih_precaucao b
	WHERE a.nr_atendimento = nr_atendimento_w
	AND b.nr_sequencia = a.nr_seq_precaucao
	AND coalesce(a.dt_inativacao::text, '') = ''
	AND coalesce(a.dt_termino::text, '') = ''
	AND coalesce(a.dt_final_precaucao::text, '') = ''
	AND (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	AND a.ie_situacao = 'A'
	ORDER BY coalesce(b.nr_seq_prioridade,0),a.nr_sequencia;


BEGIN

nr_seq_precaucao_atend_w := 0;

open C02;
loop
fetch C02 into
nr_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
begin

	open C01;
	loop
	fetch C01 into
		nr_seq_precaucao_atend_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		if (nr_seq_precaucao_atend_w > 0) then

			select max(nr_seq_precaucao),
			max(nr_seq_motivo_isol)
			into STRICT nr_seq_precaucao_w,
			nr_Seq_motivo_precaucao_w
			from atendimento_precaucao
			where nr_sequencia = nr_seq_precaucao_atend_w;

			select max(ds_precaucao)
			into STRICT ds_auxiliar_w
			from cih_precaucao
			where nr_sequencia = nr_seq_precaucao_w;

			if (coalesce(ds_retorno_w,'1') not like('%'||ds_auxiliar_w||'%')) then
				if (coalesce(ds_retorno_w::text, '') = '') then
					ds_retorno_w := ds_auxiliar_w;
				else
					ds_retorno_w := ds_retorno_w||'; '|| ds_auxiliar_w;
				end if;
			end if;
		end if;
	end loop;
	close C01;
	end;
end loop;
close C02;


return ds_retorno_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_precaucoes_paciente (cd_pessoa_fisica_p text) FROM PUBLIC;

