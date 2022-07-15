-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gera_receita_amb ( nr_atendimento_p bigint, nr_receita_p text, dt_inicio_receita_p timestamp, dt_validade_receita_p timestamp, nr_dias_receita_p bigint, ie_tipo_receita_p text, cd_medico_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, nr_seq_receita_amb_p INOUT bigint) AS $body$
DECLARE


nr_sequencia_w		fa_receita_farmacia.nr_sequencia%type;
nr_receita_w		fa_receita_farmacia.nr_receita%type;
ds_mensagem_w		varchar(2000);
qt_timestamp_prefix_rule_w bigint;
ie_outpatient_type_w  fa_receita_farmacia.ie_outpatient_type%type;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	fa_receita_farmacia a
	where	a.nr_atendimento = nr_atendimento_p
	and		a.nm_usuario_nrec = nm_usuario_p
	and		a.cd_estabelecimento = cd_estabelecimento_p
	and		a.ie_tipo_receita = 'C'
	and		coalesce(dt_liberacao::text, '') = ''
	and		trunc(a.dt_atualizacao) = trunc(clock_timestamp())
	and		not exists (SELECT	1
						from 	fa_receita_farmacia_item b
						where	b.nr_seq_receita = a.nr_sequencia);
						
	if (coalesce(nr_sequencia_w,0) = 0) then

    qt_timestamp_prefix_rule_w := fa_obter_se_regra_prefixo(cd_estabelecimento_p, cd_perfil_p);

		nr_receita_w := nr_receita_p;
		if (coalesce(nr_receita_w::text, '') = '' OR qt_timestamp_prefix_rule_w > 0) then
			SELECT * FROM fa_gerar_numero_receita( cd_estabelecimento_p, nm_usuario_p, cd_perfil_p, nr_receita_w, ds_mensagem_w) INTO STRICT nr_receita_w, ds_mensagem_w;
			
			if (nr_atendimento_p > 0) and (coalesce(nr_receita_w::text, '') = '') then
				nr_receita_w := substr(fa_obter_numero_receita(nr_atendimento_p),1,15);
			end if;
		end if;
		
		select	nextval('fa_receita_farmacia_seq')
		into STRICT	nr_sequencia_w
		;

    select coalesce(max(si_type_of_prescription),null)
    into STRICT ie_outpatient_type_w
    from cpoe_order_unit
    where cd_pessoa_fisica = coalesce(obter_pessoa_atendimento(nr_atendimento_p,'C'),0)
    and nr_atendimento = nr_atendimento_p;
		
		insert into	fa_receita_farmacia(
					nr_sequencia,
					nr_receita,
					nr_atendimento,
					cd_pessoa_fisica,
					dt_inicio_receita,
					dt_validade_receita,
					nr_dias_receita,
					cd_estabelecimento,
					cd_medico,
					ie_tipo_receita,
					ie_nivel_atencao,
					dt_receita,
					dt_atualizacao,
					dt_atualizacao_nrec,
					nm_usuario,
					nm_usuario_nrec,
          ie_outpatient_type)
				values (
					nr_sequencia_w,
					nr_receita_w,
					nr_atendimento_p,
					obter_pessoa_atendimento(nr_atendimento_p,'C'),
					dt_inicio_receita_p,
					dt_validade_receita_p,
					nr_dias_receita_p,
					cd_estabelecimento_p,
					cd_medico_p,
					ie_tipo_receita_p,
					wheb_assist_pck.get_nivel_atencao_perfil,
					clock_timestamp(),
					clock_timestamp(),
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_p,
          ie_outpatient_type_w
					);
	else
	
		update	fa_receita_farmacia
		set		dt_inicio_receita = dt_inicio_receita_p,
				dt_validade_receita = dt_validade_receita_p,
				nr_dias_receita = nr_dias_receita_p,
				nr_receita	= coalesce(nr_receita_p, nr_receita),
				ie_nivel_atencao = wheb_assist_pck.get_nivel_atencao_perfil,
				ie_tipo_receita = ie_tipo_receita_p,
				dt_atualizacao = clock_timestamp()
		where	nr_sequencia = nr_sequencia_w;
	
	end if;
				
	commit;

	nr_seq_receita_amb_p := nr_sequencia_w;	
	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gera_receita_amb ( nr_atendimento_p bigint, nr_receita_p text, dt_inicio_receita_p timestamp, dt_validade_receita_p timestamp, nr_dias_receita_p bigint, ie_tipo_receita_p text, cd_medico_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, nr_seq_receita_amb_p INOUT bigint) FROM PUBLIC;

