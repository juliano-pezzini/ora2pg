-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tx_sala_cir_tempo ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, nr_cirurgia_p bigint, dt_entrada_unidade_p timestamp, nm_usuario_p text, cd_tipo_anestesia_p text, ie_porte_p text) AS $body$
DECLARE


cd_procedimento_w 	bigint;
ie_origem_proced_w      bigint;
nr_sequencia_w		bigint;
nr_seq_atepacu_w	bigint;
cd_convenio_w		bigint;
qt_min_duracao_w	bigint;
cd_setor_atendimento_w	bigint;
dt_final_cirurgia_w	timestamp;
cd_categoria_w		varchar(10);
nr_min_final_max_w	bigint;
qt_proc_alternativo_w	bigint;
qt_procedimento_w	bigint;
nr_min_excesso_w	bigint;
nr_seq_regra_taxa_cir_w	bigint;
ie_porte_w		varchar(1);
cd_tipo_anestesia_w	varchar(10);
cd_estabelecimento_w	smallint;
dt_inicio_real_w	timestamp;
qt_porte_anest_w	smallint;
nr_seq_proc_interno_w	bigint;
cd_plano_convenio_w	varchar(10);
cd_proc_int_w		bigint;
ie_origem_proc_int_w	bigint;
cd_tipo_acomodacao_w	smallint;
ie_tipo_atendimento_w	smallint;
ie_medico_taxa_w   	varchar(1);
cd_cgc_taxa_w		varchar(14);
cd_medico_taxa_w    	varchar(10);
cd_medico_regra_w	varchar(10);
cd_profissional_w	varchar(10);
nr_seq_classificacao_w	atendimento_paciente.nr_seq_classificacao%type;
ie_certificate_type_w	procedimento.ie_proced_type%type;
cd_proc_surgical_w	bigint;
ie_origem_surgical_w	bigint;

qt_taxa_gerada_w	bigint;


C01 CURSOR FOR
	SELECT	a.cd_procedimento		cd_procedimento,
		a.ie_origem_proced		ie_origem_proced,
		coalesce(a.qt_procedimento,1)	qt_procedimento,
		a.nr_sequencia			nr_sequencia,
		coalesce(ie_porte_p,'0')		ie_porte,
		coalesce(cd_tipo_anestesia_p,'0') 	cd_tipo_anestesia,
		coalesce(a.cd_estabelecimento,0)	cd_estabelecimento,
		a.nr_seq_proc_interno		nr_seq_proc_interno
	from	convenio_regra_taxa_cir a
	where	a.ie_situacao = 'A'
	and	qt_min_duracao_w between a.nr_min_inicial and a.nr_min_final
	and	cd_convenio_w = a.cd_convenio
	and	coalesce(a.cd_tipo_anestesia,coalesce(cd_tipo_anestesia_p,'0')) = coalesce(cd_tipo_anestesia_p,'0')
	and	((coalesce(a.nr_seq_classificacao::text, '') = '') or (a.nr_seq_classificacao = nr_seq_classificacao_w))
	and	((coalesce(a.ie_certificate_type::text, '') = '') or (a.ie_certificate_type = ie_certificate_type_w))
	and     coalesce(a.ie_porte,coalesce(ie_porte_p,'0')) = coalesce(ie_porte_p,'0')
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
	and	coalesce(dt_inicio_real_w, clock_timestamp()) between coalesce(dt_inicio_vigencia, coalesce(dt_inicio_real_w, clock_timestamp())) and
		trunc(coalesce(dt_final_vigencia, coalesce(dt_inicio_real_w, clock_timestamp()))) + 86399/86400
	and	((coalesce(qt_porte_anest_w::text, '') = '') or (qt_porte_anest_w between coalesce(a.qt_porte_inicial, qt_porte_anest_w) and
							coalesce(a.qt_porte_final, qt_porte_anest_w)))
	
union all

	SELECT	a.cd_procedimento		cd_procedimento,
		a.ie_origem_proced		ie_origem_proced,
		coalesce(a.qt_procedimento,1)	qt_procedimento,
		a.nr_sequencia			nr_sequencia,
		coalesce(ie_porte_p,'0')		ie_porte,
		coalesce(cd_tipo_anestesia_p,'0') 	cd_tipo_anestesia,
		coalesce(a.cd_estabelecimento,0)	cd_estabelecimento,
		a.nr_seq_proc_interno		nr_seq_proc_interno
	from	convenio_regra_taxa_cir a
	where	ie_situacao = 'A'
	and	cd_convenio_w = a.cd_convenio
	and	qt_min_duracao_w not between a.nr_min_inicial and a.nr_min_final
	and	a.nr_min_final = (	select	max(x.nr_min_final)
					from	convenio_regra_taxa_cir x
					where	x.cd_convenio = cd_convenio_w
					and	x.ie_situacao = 'A'
					and	coalesce(x.cd_tipo_anestesia,coalesce(cd_tipo_anestesia_p,'0')) = coalesce(cd_tipo_anestesia_p,'0')
					and     coalesce(x.ie_porte,coalesce(ie_porte_p,'0')) = coalesce(ie_porte_p,'0')
					and	coalesce(x.cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0))
	and 	not exists (	select 	1
					from	convenio_regra_taxa_cir y
					where	y.ie_situacao = 'A'
					and	qt_min_duracao_w between y.nr_min_inicial and y.nr_min_final
					and	cd_convenio_w = y.cd_convenio
					and	coalesce(y.cd_tipo_anestesia,coalesce(cd_tipo_anestesia_p,'0')) = coalesce(cd_tipo_anestesia_p,'0')
					and     coalesce(y.ie_porte,coalesce(ie_porte_p,'0')) = coalesce(ie_porte_p,'0')
					and	coalesce(y.cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0))
	and	coalesce(cd_tipo_anestesia_p,'0') = coalesce(a.cd_tipo_anestesia,coalesce(cd_tipo_anestesia_p,'0'))
	and     coalesce(ie_porte_p,'0')	     = coalesce(a.ie_porte,coalesce(ie_porte_p,'0'))	
	and	((coalesce(a.nr_seq_classificacao::text, '') = '') or (a.nr_seq_classificacao = nr_seq_classificacao_w))
	and	((coalesce(a.ie_certificate_type::text, '') = '') or (a.ie_certificate_type = ie_certificate_type_w))	
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
	and	coalesce(dt_inicio_real_w, clock_timestamp()) between coalesce(dt_inicio_vigencia, coalesce(dt_inicio_real_w, clock_timestamp())) and
			trunc(coalesce(dt_final_vigencia, coalesce(dt_inicio_real_w, clock_timestamp()))) + 86399/86400
	and	((coalesce(qt_porte_anest_w::text, '') = '') or (qt_porte_anest_w between coalesce(a.qt_porte_inicial, qt_porte_anest_w) and
							coalesce(a.qt_porte_final, qt_porte_anest_w)))
	
union all

	select	coalesce(max(a.cd_proc_alternativo),0) cd_procedimento,
		coalesce(max(a.ie_orig_proced_alt),0)  ie_origem_proced,
		coalesce(max(qt_proc_alternativo_w),1) qt_procedimento,
		coalesce(max(a.nr_sequencia),0)	  nr_sequencia,
		coalesce(max(ie_porte_p),'0')	  ie_porte,
		coalesce(max(cd_tipo_anestesia_p),'0') cd_tipo_anestesia,
		coalesce(max(a.cd_estabelecimento),0) cd_estabelecimento,
		max(a.nr_seq_proc_int_alt) nr_seq_proc_interno
	from	convenio_regra_taxa_cir  a
	where	a.ie_situacao = 'A'
	and	cd_convenio_w = a.cd_convenio
	and	qt_min_duracao_w > nr_min_final_max_w
	and	((coalesce(a.nr_seq_classificacao::text, '') = '') or (a.nr_seq_classificacao = nr_seq_classificacao_w))
	and	((coalesce(a.ie_certificate_type::text, '') = '') or (a.ie_certificate_type = ie_certificate_type_w))
	and	coalesce(a.cd_tipo_anestesia,coalesce(cd_tipo_anestesia_p,'0')) = coalesce(cd_tipo_anestesia_p,'0')
	and     coalesce(a.ie_porte,coalesce(ie_porte_p,'0')) = coalesce(ie_porte_p,'0')
	and	coalesce(a.cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
	and	coalesce(dt_inicio_real_w, clock_timestamp()) between coalesce(dt_inicio_vigencia, coalesce(dt_inicio_real_w, clock_timestamp())) and
			trunc(coalesce(dt_final_vigencia, coalesce(dt_inicio_real_w, clock_timestamp()))) + 86399/86400
	and	((coalesce(qt_porte_anest_w::text, '') = '') or (qt_porte_anest_w between coalesce(a.qt_porte_inicial, qt_porte_anest_w) and
							coalesce(a.qt_porte_final, qt_porte_anest_w)))
	order by	cd_procedimento,
		ie_porte,
                cd_tipo_anestesia,
		cd_estabelecimento;

BEGIN

select	nr_min_duracao_real,
	cd_convenio,
	cd_setor_atendimento,
	coalesce(dt_fim_cirurgia,clock_timestamp()),
	coalesce(dt_inicio_real, clock_timestamp()),
	coalesce(obter_porte_anestesico_cir(nr_cirurgia),0),
	cd_categoria,
	cd_procedimento_princ,
	ie_origem_proced
into STRICT	qt_min_duracao_w,
	cd_convenio_w,
	cd_setor_atendimento_w,
	dt_final_cirurgia_w,
	dt_inicio_real_w,
	qt_porte_anest_w,
	cd_categoria_w,
	cd_proc_surgical_w,
	ie_origem_surgical_w
from	cirurgia
where	nr_cirurgia	= nr_cirurgia_p;

select 	coalesce(max(nr_seq_interno),0)
into STRICT	nr_seq_atepacu_w
from 	atend_paciente_unidade
where 	nr_atendimento 		= nr_atendimento_p
and 	dt_entrada_unidade	= dt_entrada_unidade_p;

select	max(nr_min_final)
into STRICT	nr_min_final_max_w
from	convenio_regra_taxa_cir
where	ie_situacao = 'A'
and	cd_convenio_w = cd_convenio
and	coalesce(cd_tipo_anestesia,coalesce(cd_tipo_anestesia_p,'0')) = coalesce(cd_tipo_anestesia_p,'0')
and     coalesce(ie_porte,coalesce(ie_porte_p,'0')) = coalesce(ie_porte_p,'0')
and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0);

select	max(coalesce(nr_min_excesso,0))
into STRICT	nr_min_excesso_w
from	convenio_regra_taxa_cir
where	ie_situacao = 'A'
and	cd_convenio_w = cd_convenio
and	coalesce(cd_tipo_anestesia,coalesce(cd_tipo_anestesia_p,'0')) = coalesce(cd_tipo_anestesia_p,'0')
and     coalesce(ie_porte,coalesce(ie_porte_p,'0')) = coalesce(ie_porte_p,'0')
and	coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0);

if (qt_min_duracao_w > nr_min_final_max_w) then
	if (nr_min_excesso_w = 1) then
		qt_proc_alternativo_w:= trunc(dividir((qt_min_duracao_w-nr_min_final_max_w),nr_min_excesso_w));
	else
		qt_proc_alternativo_w:= trunc(dividir((qt_min_duracao_w-nr_min_final_max_w),nr_min_excesso_w)+ 1);
	end if;
end if;

select	coalesce(cd_categoria_w, max(obter_categoria_atendimento(nr_atendimento))),
	max(obter_plano_atendimento(nr_atendimento,'C')),
	max(obter_tipo_acomod_atend(nr_atendimento,'C')),
	max(ie_tipo_atendimento),
	max(nr_seq_classificacao)
into STRICT	cd_categoria_w,
	cd_plano_convenio_w,
	cd_tipo_acomodacao_w,
	ie_tipo_atendimento_w,
	nr_seq_classificacao_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;

select	max(ie_proced_type)
into STRICT	ie_certificate_type_w
from	procedimento
where	cd_procedimento = cd_proc_surgical_w
and	ie_origem_proced = ie_origem_surgical_w;

open C01;
loop
fetch C01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	qt_procedimento_w,
	nr_seq_regra_taxa_cir_w,
	ie_porte_w,
	cd_tipo_anestesia_w,
	cd_estabelecimento_w,
	nr_seq_proc_interno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (coalesce(nr_seq_proc_interno_w,0) > 0) then
		
		SELECT * FROM Obter_Proc_Tab_Interno_Conv(nr_seq_proc_interno_w, cd_estabelecimento_p, cd_convenio_w, cd_categoria_w, cd_plano_convenio_w, cd_setor_atendimento_w, cd_proc_int_w, ie_origem_proc_int_w, cd_setor_atendimento_w, dt_final_cirurgia_w, cd_tipo_acomodacao_w, null, null, null, ie_tipo_atendimento_w, null, null, null) INTO STRICT cd_proc_int_w, ie_origem_proc_int_w;
			
		if (coalesce(cd_proc_int_w,0) > 0) and (coalesce(ie_origem_proc_int_w,0) > 0) then
			cd_procedimento_w	:= cd_proc_int_w;
			ie_origem_proced_w	:= ie_origem_proc_int_w;
		end if;
		
	end if;
	
	if (cd_procedimento_w > 0) and (ie_origem_proced_w > 0) and (nr_seq_regra_taxa_cir_w > 0) then
		
		-- Verificar se já foi gerada a taxa para a cirurgia
		select	count(*)
		into STRICT	qt_taxa_gerada_w
		from	procedimento_paciente
		where	nr_atendimento = nr_atendimento_p
		and	nr_cirurgia = nr_cirurgia_p
		and	nr_seq_regra_taxa_cir = nr_seq_regra_taxa_cir_w
		and	cd_procedimento = cd_procedimento_w
		and	ie_origem_proced = ie_origem_proced_w
		and	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_w,0)) = coalesce(nr_seq_proc_interno_w,0);
		
		if (coalesce(qt_taxa_gerada_w,0) = 0)  then
		
			SELECT * FROM consiste_medico_executor(cd_estabelecimento_p, cd_convenio_w, cd_setor_atendimento_w, cd_procedimento_w, ie_origem_proced_w, ie_tipo_atendimento_w, null, null, ie_medico_taxa_w, cd_cgc_taxa_w, cd_medico_regra_w, cd_profissional_w, null, dt_final_cirurgia_w, nr_seq_classificacao_w, null, null, null) INTO STRICT ie_medico_taxa_w, cd_cgc_taxa_w, cd_medico_regra_w, cd_profissional_w;

			/* ie_medico_taxa_w dominio 77 n-não pode ter,o-opcional,x-obrigatório */

			if (ie_medico_taxa_w = 'F') then
				cd_medico_taxa_w := cd_medico_regra_w;
			else
				cd_medico_taxa_w := null;
			end if;
		
			select 	nextval('procedimento_paciente_seq')
			into STRICT 	nr_sequencia_w
			;

			
			insert  into procedimento_paciente(	nr_sequencia,
					nr_atendimento,
					dt_entrada_unidade, 
					cd_procedimento,
					dt_procedimento,
					qt_procedimento,
					nm_usuario,
					cd_convenio,
					cd_categoria,
					vl_procedimento,
					vl_medico,
					vl_anestesista,
					vl_materiais,
					dt_acerto_conta,
					vl_auxiliares, 
					vl_custo_operacional, 
					tx_medico, 
					tx_anestesia,	
					nr_cirurgia,
					cd_medico_executor,
					cd_cgc_prestador,
					cd_pessoa_fisica,
					nr_doc_convenio, 
					cd_setor_atendimento, 
					ie_origem_proced,
					nr_seq_atepacu,
					dt_atualizacao,
					dt_conta,
					nr_seq_regra_taxa_cir,
					nr_seq_proc_interno,
					ds_observacao) 
			values (	nr_sequencia_w,
					nr_atendimento_p, 
					dt_entrada_unidade_p, 
					cd_procedimento_w,
					dt_final_cirurgia_w, 
					qt_procedimento_w, 
					nm_usuario_p,
					cd_convenio_w, 
					cd_categoria_w,
					0, 
					0, 
					0, 
					0, 
					null, 
					0, 
					0, 
					0, 
					0, 
					nr_cirurgia_p,
					cd_medico_taxa_w,
					cd_cgc_taxa_w,
					cd_profissional_w,
					null, 	
					cd_setor_atendimento_w,
					ie_origem_proced_w, 
					nr_seq_atepacu_w,
					dt_final_cirurgia_w,
					dt_final_cirurgia_w,
					nr_seq_regra_taxa_cir_w,
					nr_seq_proc_interno_w,
					wheb_mensagem_pck.get_texto(297848));
			
			CALL Atualiza_Preco_Servico(nr_sequencia_w,'Tasy');
			
			CALL gerar_lancamento_automatico(nr_atendimento_p, null, 34, nm_usuario_p, nr_sequencia_w,null,null,null,null,null);
			
		end if;
		
	end if;
	end;
	

end loop;
close C01;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tx_sala_cir_tempo ( cd_estabelecimento_p bigint, nr_atendimento_p bigint, nr_cirurgia_p bigint, dt_entrada_unidade_p timestamp, nm_usuario_p text, cd_tipo_anestesia_p text, ie_porte_p text) FROM PUBLIC;
