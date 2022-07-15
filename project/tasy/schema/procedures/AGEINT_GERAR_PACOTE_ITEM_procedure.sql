-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_pacote_item ( nr_seq_ageint_p bigint, nr_seq_pacote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_classif_agend_p bigint) AS $body$
DECLARE


ie_tipo_acomod_w                varchar(2);

cd_procedimento_w               bigint;
ie_origem_proced_w              bigint;
vl_honorario_w                  double precision;
vl_pacote_w                     double precision;
qt_dias_pacote_w                integer;
vl_anestesista_w                double precision;
qt_reg_existe_w                 bigint;
cd_material_w                   bigint;
ds_documento_w                  text;
ie_procedimento_regra_w         varchar(1):= 'S';
ie_material_regra_w             varchar(1):= 'S';
qt_limite_w                     bigint;
ie_qtde_limite_pacote_w         varchar(1);

nr_sequencia_w                  bigint;
NR_SEQ_PAC_ACOMOD_w             bigint;
ie_insere_w                     varchar(1):= 'S';

nr_seq_orc_proced_w             bigint;
ie_gera_todos_acomodacao_w	varchar(1):= 'S';
pr_orcamento_w			double precision;

nr_seq_proc_interno_w		bigint;
nr_seq_proc_pacote_w		bigint;

tam_lista_w		bigint;
ie_pos_virgula_w	smallint	:= 0;
ie_agendavel_w			varchar(1);
ie_pacote_w		varchar(1);
ie_tipo_agendamento_w	varchar(15);
ie_tipo_convenio_w	smallint;

nr_seq_ageint_check_list_w	bigint;
ie_gerar_check_list_w		varchar(1);
nr_classif_agend_w		bigint;
ie_exige_classif_w		varchar(1);
ie_tipo_acomod_integrada_w	varchar(2);
cd_convenio_w			agenda_integrada. cd_convenio %type;
cd_categoria_w			agenda_integrada. cd_categoria %type;
ie_tipo_atendimento_w		agenda_integrada. ie_tipo_atendimento %type;
cd_plano_w			agenda_integrada. cd_plano %type;
cd_procedencia_w		agenda_integrada. cd_procedencia %type;
cd_estabelecimento_w		agenda_integrada. cd_estabelecimento %type;
cd_regra_honorario_w		varchar(5);
ie_conta_honorario_w		varchar(1);
ie_calcula_honorario_w		varchar(1)		:= 'S';
cd_cgc_honorario_w		varchar(14);
cd_pessoa_honorario_w		varchar(10);
nr_seq_criterio_w		bigint;
vl_auxiliares_w			pacote_tipo_acomodacao.vl_auxiliares%type;
vl_procedimento_w		double precision := 0;

c01 CURSOR FOR
        SELECT  a.cd_procedimento,
                a.ie_origem_proced,
                a.vl_honorario,
                a.vl_pacote,
                a.qt_dias_pacote,
                a.vl_anestesista,
		a.vl_auxiliares,
                1,
                a.nr_sequencia,
		a.nr_seq_proc_interno,
		coalesce(c.ie_agendavel, 'N')
        from    pacote_tipo_acomodacao a,
		pacote c
        where   a.nr_seq_pacote   = nr_seq_pacote_p
	and	a.nr_seq_pacote	= c.nr_seq_pacote
	and	Ageint_Obter_Se_Pacote_Acomod(a.ie_tipo_acomod) = 'S'
	and	((a.ie_tipo_acomod = ie_tipo_acomod_integrada_w) or (coalesce(ie_tipo_acomod_integrada_w::text, '') = ''))
	and 	coalesce(a.ie_situacao, 'A') = 'A'
	and 	trunc(coalesce(a.dt_vigencia,clock_timestamp())) <= clock_timestamp()
	and 	trunc(coalesce(a.dt_vigencia_final,clock_timestamp()))+ 86399/86400 >= clock_timestamp()
        and     coalesce(a.dt_vigencia,clock_timestamp()) = (
                                SELECT  max(coalesce(dt_vigencia,clock_timestamp()))
                                from    Pacote_Tipo_Acomodacao b
                                where   nr_seq_pacote                   = nr_seq_pacote_p
                                and     coalesce(ie_situacao, 'A')           = 'A'
                                and     b.cd_procedimento               = a.cd_procedimento
                                and     b.ie_origem_proced              = a.ie_origem_proced
				and 	trunc(coalesce(b.dt_vigencia,clock_timestamp())) <= clock_timestamp()
				and 	trunc(coalesce(b.dt_vigencia_final,clock_timestamp()))+ 86399/86400 >= clock_timestamp());


c02 CURSOR FOR
        SELECT  cd_material,
                coalesce(qt_limite,1),
                NR_SEQ_PAC_ACOMOD,
		pr_orcamento
        from    pacote_material
        where   nr_seq_pacote   = nr_seq_pacote_p
        and     ie_inclui_exclui = 'I'
        and     coalesce(ie_material_regra_w,'S') = 'S'
        and     (cd_material IS NOT NULL AND cd_material::text <> '');

c05 CURSOR FOR
        SELECT  cd_procedimento,
                ie_origem_proced,
                0,
                0,
                0,
                0,
                coalesce(qt_limite,1),
                NR_SEQ_PAC_ACOMOD,
		nr_seq_proc_interno
        from    pacote_procedimento
        where   nr_seq_pacote   = nr_seq_pacote_p
        and     ie_inclui_exclui = 'I'
        and ((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (nr_seq_proc_interno IS NOT NULL AND nr_seq_proc_interno::text <> ''))
	and 	coalesce(ie_agendavel,'N') = 'S'
        and     coalesce(ie_procedimento_regra_w,'S') = 'A';

C03 CURSOR FOR
	SELECT	nr_sequencia
	from	ageint_proc_pacote
	where	nr_seq_ageint	= nr_seq_ageint_p
	
union

	SELECT	nr_sequencia
	from	agenda_integrada_item
	where	nr_seq_agenda_int	= nr_seq_ageint_p
	and	coalesce(ie_pacote, 'N')	= 'S'
	order by 1;


BEGIN

ie_procedimento_regra_w 	:= obter_valor_param_usuario(106, 20, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
ie_qtde_limite_pacote_w 	:= obter_valor_param_usuario(106, 38, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
ie_material_regra_w     	:= obter_valor_param_usuario(106, 42, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);
ie_gera_todos_acomodacao_w     	:= coalesce(obter_valor_param_usuario(106, 62, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento),'S');

select  coalesce(max(ie_classificacao),'X')
into STRICT    ie_tipo_acomod_w
from    tipo_acomodacao b,
        orcamento_paciente a
where a.cd_tipo_acomodacao = b.cd_tipo_acomodacao;

select	max(b.ie_tipo_convenio)
into STRICT	ie_tipo_convenio_w
from	agenda_integrada a,
	convenio b
where	a.nr_sequencia	= nr_seq_ageint_p
and	a.cd_convenio	= b.cd_convenio;

select	max(ie_tipo_acomod),

	max(cd_convenio),
	max(cd_categoria),
	max(ie_tipo_atendimento),
	max(cd_plano),
	max(cd_procedencia),
	max(cd_estabelecimento)
into STRICT	ie_tipo_acomod_integrada_w,
	cd_convenio_w,
	cd_categoria_w,
	ie_tipo_atendimento_w,
	cd_plano_w,
	cd_procedencia_w,
	cd_estabelecimento_w
from	agenda_integrada
where	nr_sequencia	= nr_seq_ageint_p;

if (nr_seq_pacote_p IS NOT NULL AND nr_seq_pacote_p::text <> '') and (nr_seq_ageint_p IS NOT NULL AND nr_seq_ageint_p::text <> '') then

	-- Pacote
	open c01;
	loop
	fetch c01 into
		cd_procedimento_w,
		ie_origem_proced_w,
		vl_honorario_w,
		vl_pacote_w,
		qt_dias_pacote_w,
		vl_anestesista_w,
		vl_auxiliares_w,
		qt_limite_w,
		nr_sequencia_w,
		nr_seq_proc_interno_w,
		ie_agendavel_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		if (ie_qtde_limite_pacote_w = 'N') then
			qt_limite_w:= 1;
		end if;

		if (coalesce(nr_seq_proc_interno_w::text, '') = '') then
			if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
				select	coalesce(max(nr_sequencia),0)
				into STRICT	nr_seq_proc_interno_w
				from	proc_interno
				where	cd_procedimento		= cd_procedimento_w
				and	ie_origem_proced	= ie_origem_proced_w;

				if (nr_seq_proc_interno_w	= 0) then
					select	max(nr_Seq_proc_interno)
					into STRICT	nr_Seq_proc_interno_w
					from	proc_interno_conv
					where	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w;
				end if;
			end if;
		elsif (coalesce(cd_procedimento_w::text, '') = '') or (coalesce(ie_origem_proced_w::text, '') = '') then
			SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_w, null, null, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
		end if;

		if (ie_tipo_convenio_w = 1) then
			SELECT * FROM obter_regra_honorario(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, clock_timestamp(), ie_tipo_atendimento_w, null, null, null, null, null, 'S', null, cd_plano_w, cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w, null, null, null, null, null, null, cd_procedencia_w, null, null, nr_Seq_proc_interno_w, null) INTO STRICT cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w;
			if (ie_conta_honorario_w = 'S') then
				vl_procedimento_w	:= coalesce(vl_pacote_w,0) + coalesce(vl_honorario_w,0) + coalesce(vl_anestesista_w,0) + coalesce(vl_auxiliares_w,0);
			else
				vl_procedimento_w	:= coalesce(vl_pacote_w,0);
			end if;
		else
			vl_procedimento_w := 0;
		end if;

		if (ie_agendavel_w	= 'N') then
			select	nextval('ageint_proc_pacote_seq')
			into STRICT	nr_seq_proc_pacote_w
			;

			insert into ageint_proc_pacote(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_proc_interno,
				cd_procedimento,
				ie_origem_proced,
				nr_seq_ageint,
				vl_pacote)
			values (nr_seq_proc_pacote_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_interno_w,
				cd_procedimento_w,
				ie_origem_proced_w,
				nr_seq_ageint_p,
				vl_procedimento_w);
		else
			select	nextval('agenda_integrada_item_seq')
			into STRICT	nr_seq_proc_pacote_w
			;

			ie_tipo_agendamento_w	:= Ageint_Obter_Tipo_Ag_Exame(nr_seq_proc_interno_w, cd_estabelecimento_p, nm_usuario_p);

			ie_gerar_check_list_w	:= substr(ageint_obter_se_proc_check(nr_seq_proc_interno_w,nr_seq_ageint_p, cd_estabelecimento_p),1,1);

			if (ie_gerar_check_list_w = 'S') then
				select	nextval('ageint_check_list_paciente_seq')
				into STRICT	nr_seq_ageint_check_list_w
				;

				insert into ageint_check_list_paciente(nr_sequencia,
									nr_seq_ageint,
									dt_atualizacao,
									nm_usuario)
								values (nr_seq_ageint_check_list_w,
									nr_seq_ageint_p,
									clock_timestamp(),
									nm_usuario_p);
				commit;

				CALL Ageint_Gerar_Check_List(nr_seq_ageint_check_list_w,nr_seq_proc_interno_w,nr_seq_ageint_p,nm_usuario_p, cd_estabelecimento_p);
			end if;

			nr_classif_agend_w	:= null;

			select	coalesce(max(ie_exige_classif_item_ageint),'N')
			into STRICT	ie_exige_classif_w
			from	proc_interno
			where	nr_sequencia	= nr_seq_proc_interno_w;

			if (ie_exige_classif_w = 'S') then
				nr_classif_agend_w := nr_classif_agend_p;
			end if;

			insert into agenda_integrada_item(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_proc_interno,
				cd_procedimento,
				ie_origem_proced,
				ie_tipo_agendamento,
				--nr_seq_proc_pacote,
				vl_item,
				nr_seq_agenda_int,
				ie_pacote,
				nr_seq_pacote,
				nr_classificacao_agend,
				nr_seq_pac_tipo_acomod)
			values (nr_seq_proc_pacote_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_interno_w,
				cd_procedimento_w,
				ie_origem_proced_w,
				ie_tipo_agendamento_w,
				--nr_seq_proc_pacote_w,
				vl_procedimento_w,
				nr_seq_ageint_p,
				'S',
				nr_seq_pacote_p,
				nr_classif_agend_w,
				nr_sequencia_w);

			CALL Ageint_gerar_anexos_proc(nr_seq_ageint_p,nr_seq_proc_interno_w,cd_estabelecimento_p,nm_usuario_p);
		end if;

	end loop;
	close c01;

	open c05;
	loop
	fetch c05 into
		cd_procedimento_w,
		ie_origem_proced_w,
		vl_honorario_w,
		vl_pacote_w,
		qt_dias_pacote_w,
		vl_anestesista_w,
		qt_limite_w,
		NR_SEQ_PAC_ACOMOD_w,
		nr_seq_proc_interno_w;
	EXIT WHEN NOT FOUND; /* apply on c05 */

		if (ie_qtde_limite_pacote_w = 'N') then
			qt_limite_w:= 1;
		end if;

		ie_insere_w:= 'S';
		if (coalesce(nr_sequencia_w,0) > 0) and (coalesce(NR_SEQ_PAC_ACOMOD_w,0) > 0) and (nr_sequencia_w <> NR_SEQ_PAC_ACOMOD_w) then
			ie_insere_w:= 'N';
		end if;

		if (coalesce(nr_seq_proc_interno_w::text, '') = '') then
			if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') then
				select	coalesce(max(nr_sequencia),0)
				into STRICT	nr_seq_proc_interno_w
				from	proc_interno
				where	cd_procedimento		= cd_procedimento_w
				and	ie_origem_proced	= ie_origem_proced_w;

				if (nr_seq_proc_interno_w	= 0) then
					select	max(nr_Seq_proc_interno)
					into STRICT	nr_Seq_proc_interno_w
					from	proc_interno_conv
					where	cd_procedimento		= cd_procedimento_w
					and	ie_origem_proced	= ie_origem_proced_w;
				end if;
			end if;
		elsif (coalesce(cd_procedimento_w::text, '') = '') or (coalesce(ie_origem_proced_w::text, '') = '') then
			SELECT * FROM obter_proc_tab_interno(nr_seq_proc_interno_w, null, null, null, cd_procedimento_w, ie_origem_proced_w, null, null) INTO STRICT cd_procedimento_w, ie_origem_proced_w;
		end if;

		if (coalesce(ie_insere_w,'S') = 'S') then

			ie_gerar_check_list_w	:= substr(ageint_obter_se_proc_check(nr_seq_proc_interno_w,nr_seq_ageint_p, cd_estabelecimento_p),1,1);

			if (ie_gerar_check_list_w = 'S') then
				select	nextval('ageint_check_list_paciente_seq')
				into STRICT	nr_seq_ageint_check_list_w
				;

				insert into ageint_check_list_paciente(nr_sequencia,
									nr_seq_ageint,
									dt_atualizacao,
									nm_usuario)
								values (nr_seq_ageint_check_list_w,
									nr_seq_ageint_p,
									clock_timestamp(),
									nm_usuario_p);
				commit;

				CALL Ageint_Gerar_Check_List(nr_seq_ageint_check_list_w,nr_seq_proc_interno_w,nr_seq_ageint_p,nm_usuario_p, cd_estabelecimento_p);
			end if;

			nr_classif_agend_w	:= null;

			select	coalesce(max(ie_exige_classif_item_ageint),'N')
			into STRICT	ie_exige_classif_w
			from	proc_interno
			where	nr_sequencia	= nr_seq_proc_interno_w;

			if (ie_exige_classif_w = 'S') then
				nr_classif_agend_w := nr_classif_agend_p;
			end if;

			insert into agenda_integrada_item(nr_sequencia,
				nr_seq_agenda_int,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_proc_interno,
				ie_tipo_agendamento,
				vl_item,
				vl_medico,
				vl_anestesista,
				vl_auxiliares,
				vl_custo_operacional,
				vl_materiais,
				ds_observacao,
				vl_lanc_auto,
				cd_procedimento,
				ie_origem_proced,
				nr_seq_proc_pacote,
				nr_seq_pacote,
				nr_classificacao_agend)
			values (nextval('agenda_integrada_item_seq'),
				nr_seq_ageint_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_proc_interno_w,
				'E',
				0,
				0,
				0,
				0,
				0,
				0,
				obter_desc_expressao(777040),
				0,
				cd_procedimento_w,
				ie_origem_proced_w,
				CASE WHEN ie_agendavel_w='N' THEN  nr_seq_proc_pacote_w  ELSE null END ,
				nr_seq_pacote_p,
				nr_classif_agend_w);

			CALL Ageint_gerar_anexos_proc(nr_seq_ageint_p,nr_seq_proc_interno_w,cd_estabelecimento_p,nm_usuario_p);
		end if;

	end loop;
	close c05;
end if;

commit;

open C03;
loop
fetch C03 into
	nr_seq_proc_pacote_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin
	if (ie_agendavel_w	= 'N') then
		ie_pacote_w	:= 'S';
	else
		ie_pacote_w	:= 'N';
	end if;
	CALL ageint_gerar_lanc_auto(nr_seq_ageint_p, 34, nr_seq_proc_pacote_w, ie_pacote_w, nm_usuario_p);
	end;
end loop;
close C03;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_pacote_item ( nr_seq_ageint_p bigint, nr_seq_pacote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_classif_agend_p bigint) FROM PUBLIC;

