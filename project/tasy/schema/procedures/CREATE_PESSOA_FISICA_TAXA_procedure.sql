-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE create_pessoa_fisica_taxa ( qt_dias_pagamento_p bigint, dt_pagamento_p timestamp, nr_seq_justificativa_p bigint, cd_pessoa_fisica_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ie_obriga_pag_adicional_p text, nr_seq_interno_p atend_categoria_convenio.nr_seq_interno%type, ie_wdbp_dayspatient_p text default 'N', nr_seq_atecaco_p pessoa_fisica_taxa.nr_seq_atecaco%type default 0) AS $body$
DECLARE


nr_sequencia_w			pessoa_fisica_taxa.nr_sequencia%type;
private_insurance_w		parametro_faturamento.cd_convenio_partic%type;
private_category_w		parametro_faturamento.cd_categoria_partic%type;
qt_same_insurance_w 		smallint;
dt_inicio_vigencia_w		timestamp;
atend_categoria_convenio_w 	atend_categoria_convenio%rowtype;
atendCategoriaConvenioSeq	atend_categoria_convenio.nr_seq_interno%type;
cd_convenio_w			atend_categoria_convenio.cd_convenio%type;
cd_categoria_w			atend_categoria_convenio.cd_categoria%type;
nr_seq_episodio_w		atendimento_paciente.nr_seq_episodio%type;
cd_estabelecimento_atend_w	atendimento_paciente.cd_estabelecimento%type;
pessoa_fisica_taxa_w  		pessoa_fisica_taxa%rowtype;

  item RECORD;

BEGIN

select  max(nr_seq_episodio),
	coalesce(max(cd_estabelecimento), obter_estabelecimento_ativo)
into STRICT	nr_seq_episodio_w,
	cd_estabelecimento_atend_w
from    atendimento_paciente apt
where   apt.nr_atendimento = nr_atendimento_p;



if (ie_obriga_pag_adicional_p = 'S') then
	select	max(cd_convenio_partic),
		max(cd_categoria_partic)
	into STRICT 	private_insurance_w,
		private_category_w
	from 	parametro_faturamento
	where	coalesce(cd_estabelecimento, cd_estabelecimento_atend_w) = cd_estabelecimento_atend_w;

	if (private_insurance_w IS NOT NULL AND private_insurance_w::text <> '' AND private_category_w IS NOT NULL AND private_category_w::text <> '') then

		if (coalesce(nr_seq_interno_p,0) > 0) then

			select	coalesce(obter_data_nascto_pf(cd_pessoa_fisica_p), max(dt_inicio_vigencia))
			into STRICT	dt_inicio_vigencia_w
			from	atend_categoria_convenio
			where	nr_seq_interno	= nr_seq_interno_p;

		end if;

		select 	count(1)
		into STRICT 	qt_same_insurance_w
		from 	atend_categoria_convenio
		where 	nr_atendimento 	= nr_atendimento_p
		and 	cd_convenio 	= private_insurance_w
		and 	cd_categoria 	= private_category_w;

		if (qt_same_insurance_w = 0) then

			select 	nextval('atend_categoria_convenio_seq')
			into STRICT	atendCategoriaConvenioSeq
			;

			atend_categoria_convenio_w.nr_seq_interno := atendCategoriaConvenioSeq;
			atend_categoria_convenio_w.nr_atendimento := nr_atendimento_p;
			atend_categoria_convenio_w.cd_convenio := private_insurance_w;
			atend_categoria_convenio_w.cd_categoria := private_category_w;
			atend_categoria_convenio_w.dt_inicio_vigencia := coalesce(dt_inicio_vigencia_w,obter_data_entrada(nr_atendimento_p));
			atend_categoria_convenio_w.dt_atualizacao := clock_timestamp();
			atend_categoria_convenio_w.nm_usuario := nm_usuario_p;
			atend_categoria_convenio_w.nr_prioridade := obter_prior_padrao_conv_atend(nr_atendimento_p, private_insurance_w);
			atend_categoria_convenio_w.ie_tipo_conveniado := 6;

			insert into atend_categoria_convenio values (atend_categoria_convenio_w.*);
			commit;
		end if;

		if (ie_wdbp_dayspatient_p = 'S' and (nr_seq_episodio_w IS NOT NULL AND nr_seq_episodio_w::text <> '')) then

			for item in (	SELECT  acc.nr_atendimento
					from    atend_categoria_convenio acc
					where   acc.nr_atendimento in ( select  apt.nr_atendimento
									from    episodio_paciente     ep,
										atendimento_paciente  apt
									where   ep.nr_sequencia = apt.nr_seq_episodio
									and     ep.nr_sequencia = nr_seq_episodio_w
									and     apt.nr_atendimento <> nr_atendimento_p)
					  and     acc.cd_convenio <> private_insurance_w
					  and     acc.cd_categoria <> private_category_w) loop
				
				CALL replicar_convenios_atendimento(nr_seq_episodio_w, nr_atendimento_p, item.nr_atendimento);
				
			end loop;
		end if;
	end if;
end if;

if (ie_obriga_pag_adicional_p IS NOT NULL AND ie_obriga_pag_adicional_p::text <> '') then
	select	max(nr_sequencia)
	into STRICT 	nr_sequencia_w
	from 	pessoa_fisica_taxa
	where 	cd_pessoa_fisica = cd_pessoa_fisica_p
	and 	nr_atendimento = nr_atendimento_p
	and 	nr_seq_atecaco = nr_seq_interno_p;

	if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then

		update	pessoa_fisica_taxa
		set	nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp(),
			qt_dias_pagamento = qt_dias_pagamento_p,
			dt_pagamento = dt_pagamento_p,
			nr_seq_justificativa = nr_seq_justificativa_p,
			ie_obriga_pag_adicional = ie_obriga_pag_adicional_p
		where 	nr_sequencia = nr_sequencia_w;
		
		select	max(acc.cd_convenio),
				max(acc.cd_categoria)
		into STRICT	cd_convenio_w,
				cd_categoria_w
		from	atend_categoria_convenio acc
		where	nr_seq_interno	= nr_seq_atecaco_p;

		if ((cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') and (cd_categoria_w IS NOT NULL AND cd_categoria_w::text <> '') and (nr_seq_episodio_w IS NOT NULL AND nr_seq_episodio_w::text <> '')) then
			for item in (	SELECT  pft.nr_sequencia
							from    pessoa_fisica_taxa pft
							where   pft.nr_seq_atecaco in (	select  acc.nr_seq_interno
															from    atend_categoria_convenio acc
															where   acc.nr_atendimento in ( select  apt.nr_atendimento
																							from    episodio_paciente     ep,
																									atendimento_paciente  apt
																							where   ep.nr_sequencia = apt.nr_seq_episodio
																							and     ep.nr_sequencia = nr_seq_episodio_w
																							)
															and     acc.cd_convenio = cd_convenio_w
															)
						)loop

				update	pessoa_fisica_taxa
				set		nm_usuario = nm_usuario_p,
						dt_atualizacao = clock_timestamp(),
						qt_dias_pagamento = qt_dias_pagamento_p,
						dt_pagamento = dt_pagamento_p,
						nr_seq_justificativa = nr_seq_justificativa_p,
						ie_obriga_pag_adicional = ie_obriga_pag_adicional_p
				where 	nr_sequencia = item.nr_sequencia;						
			end loop;
		end if;

	elsif (ie_wdbp_dayspatient_p = 'N') then

		insert into pessoa_fisica_taxa(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						cd_pessoa_fisica,
						qt_dias_pagamento,
						nr_seq_justificativa,
						dt_pagamento,
						nr_atendimento,
						ie_obriga_pag_adicional,
						nr_seq_atecaco)
		values (nextval('pessoa_fisica_taxa_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_p,
			qt_dias_pagamento_p,
			nr_seq_justificativa_p,
			dt_pagamento_p,
			nr_atendimento_p,
			ie_obriga_pag_adicional_p,
			nr_seq_interno_p);

	elsif (ie_wdbp_dayspatient_p = 'S' and coalesce(nr_seq_atecaco_p, 0) > 0) then
		
		select	max(acc.cd_convenio),
			max(acc.cd_categoria)
		into STRICT	cd_convenio_w,
			cd_categoria_w
		from	atend_categoria_convenio acc
		where	nr_seq_interno	= nr_seq_atecaco_p;

		if ((cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') and (cd_categoria_w IS NOT NULL AND cd_categoria_w::text <> '') and (nr_seq_episodio_w IS NOT NULL AND nr_seq_episodio_w::text <> ''))	then

			for item in (	SELECT  acc.nr_seq_interno					
					from    atend_categoria_convenio acc,
						atendimento_paciente apt
					where   acc.nr_atendimento = apt.nr_atendimento
					and     acc.cd_convenio =  cd_convenio_w
					and	acc.cd_categoria = cd_categoria_w
					and     apt.nr_atendimento in ( select  nr_atendimento
									from    atendimento_paciente ap
									where   ap.nr_atendimento <> nr_atendimento_p
									and     ap.nr_seq_episodio = nr_seq_episodio_w))loop

				 pessoa_fisica_taxa_w.qt_dias_pagamento          := qt_dias_pagamento_p;
				 pessoa_fisica_taxa_w.nr_seq_justificativa       := nr_seq_justificativa_p;
				 pessoa_fisica_taxa_w.nr_seq_atecaco             := item.nr_seq_interno;
				 pessoa_fisica_taxa_w.nr_atendimento             := nr_atendimento_p;
				 pessoa_fisica_taxa_w.nm_usuario_nrec            := nm_usuario_p;
				 pessoa_fisica_taxa_w.nm_usuario                 := nm_usuario_p;
				 pessoa_fisica_taxa_w.ie_obriga_pag_adicional    := ie_obriga_pag_adicional_p;
				 pessoa_fisica_taxa_w.dt_pagamento               := dt_pagamento_p;
				 pessoa_fisica_taxa_w.dt_atualizacao_nrec        := clock_timestamp();
				 pessoa_fisica_taxa_w.dt_atualizacao             := clock_timestamp();
				 pessoa_fisica_taxa_w.cd_pessoa_fisica           := cd_pessoa_fisica_p;
				
				 select nextval('pessoa_fisica_taxa_seq')
				 into STRICT	pessoa_fisica_taxa_w.nr_sequencia
				;
				
				 insert into pessoa_fisica_taxa values (pessoa_fisica_taxa_w.*);
			
			end loop;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE create_pessoa_fisica_taxa ( qt_dias_pagamento_p bigint, dt_pagamento_p timestamp, nr_seq_justificativa_p bigint, cd_pessoa_fisica_p bigint, nr_atendimento_p bigint, nm_usuario_p text, ie_obriga_pag_adicional_p text, nr_seq_interno_p atend_categoria_convenio.nr_seq_interno%type, ie_wdbp_dayspatient_p text default 'N', nr_seq_atecaco_p pessoa_fisica_taxa.nr_seq_atecaco%type default 0) FROM PUBLIC;
