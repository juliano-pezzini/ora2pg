-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_obs_agenda_capt ( nr_seq_captacao_p bigint) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:  obter descrição do campo observação da indicação, demanda espontanea ou
	busca empresarial da HDM - captação
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_busca_emp_w		mprev_busca_empresarial.nr_sequencia%type;
nr_seq_indicacao_w		mprev_indicacao_paciente.nr_sequencia%type;
nr_seq_demanda_espont_w		mprev_demanda_espont.nr_sequencia%type;
ds_observacao_w			varchar(4000);



BEGIN
if (nr_seq_captacao_p IS NOT NULL AND nr_seq_captacao_p::text <> '') then

	select	nr_seq_busca_emp,
		nr_seq_indicacao,
		nr_seq_demanda_espont
	into STRICT	nr_seq_busca_emp_w,
		nr_seq_indicacao_w,
		nr_seq_demanda_espont_w
	from 	mprev_captacao
	where	nr_sequencia = nr_seq_captacao_p;

	if (nr_seq_busca_emp_w IS NOT NULL AND nr_seq_busca_emp_w::text <> '') then
		select	ds_observacao
		into STRICT	ds_observacao_w
		from	mprev_busca_empresarial
		where 	nr_sequencia = nr_seq_busca_emp_w;
	end if;

	if (nr_seq_indicacao_w IS NOT NULL AND nr_seq_indicacao_w::text <> '') then
		select	ds_observacao
		into STRICT	ds_observacao_w
		from	mprev_indicacao_paciente
		where 	nr_sequencia = nr_seq_indicacao_w;
	end if;

	if (nr_seq_demanda_espont_w IS NOT NULL AND nr_seq_demanda_espont_w::text <> '') then
		select	ds_observacao
		into STRICT	ds_observacao_w
		from	mprev_demanda_espont
		where	nr_sequencia = nr_seq_demanda_espont_w;
	end if;
end if;

if (coalesce(ds_observacao_w::text, '') = '') then
	ds_observacao_w := '';
end if;

return	ds_observacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_obs_agenda_capt ( nr_seq_captacao_p bigint) FROM PUBLIC;

