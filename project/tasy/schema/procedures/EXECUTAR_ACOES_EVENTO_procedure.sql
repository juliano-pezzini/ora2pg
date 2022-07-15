-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE executar_acoes_evento ( nr_sequencia_p bigint,  --1
 ie_opcao_p text, nr_cirurgia_p bigint, --2
 dt_evento_p timestamp, nr_seq_evento_p bigint,  --3
 nm_usuario_p text, nr_seq_pepo_p bigint, nr_atendimento_p bigint, --6
 ie_cirurgia_p text, dados_evento_cirurgia_p INOUT text, ie_status_cirurgia_p INOUT text, realizar_proc_previstos_p INOUT text, --4
 ie_consiste_disp_p INOUT text, --5
 ie_atendimento_disp_p INOUT text, --6
 ie_gera_movimentacao_p INOUT text, ie_finaliza_movimentacao_p INOUT text, ie_focar_prescricao_p INOUT text, ie_executa_procedimentos_p INOUT text, dt_inicio_prevista_p INOUT timestamp, qt_tempo_min_p INOUT bigint, qt_resumo_agente_p INOUT bigint, ie_imprime_relatorio_p INOUT text, ie_java_html_p text default 'N') AS $body$
DECLARE

				
dados_evento_cirurgia_w		varchar(5);
ie_status_cirurgia_w		varchar(3);
realizar_proc_previstos_w	varchar(1);
ie_executa_procedimentos_w	varchar(1);
qt_cirurgia_w			bigint;
ie_consiste_disp_w		varchar(1);
ie_atendimento_disp_w		varchar(1);
ie_gera_movimentacao_w		varchar(1);	
ie_finaliza_movimentacao_w	varchar(1);
ie_focar_prescricao_w		varchar(1);
ie_finaliza_equipamento_w	varchar(1);
dt_evento_w			timestamp;
dt_inicio_prevista_w		timestamp;
qt_tempo_min_w			bigint;
ie_aviso_dispensacao_w		varchar(1);
qt_resumo_agente_w		bigint;
ie_imprime_relatorio_w		varchar(1) := 'N';
ie_fim_taxa_sala_porte_w           evento_cirurgia.ie_fim_taxa_sala_porte%type;
ie_gera_taxa_porte_w				varchar(1) := 'S';
cd_estabelecimento_w	smallint;


BEGIN

select	coalesce(max(cd_estabelecimento),OBTER_ESTABELECIMENTO_ATIVO)
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento	=	nr_atendimento_p;	

ie_gera_taxa_porte_w := obter_param_usuario(872, 536, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_taxa_porte_w);

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	begin
	dados_evento_cirurgia_w := obter_dados_evento_cirurgia(nr_sequencia_p, ie_opcao_p); --1
	end;
end if;

if (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then
	begin
	select	ie_status_cirurgia,  --2
		dt_inicio_prevista
	into STRICT	ie_status_cirurgia_w,
		dt_inicio_prevista_w
	from	cirurgia
	where	nr_cirurgia = nr_cirurgia_p;
	
	select	count(*)
	into STRICT	qt_cirurgia_w
	from	cirurgia
	where	nr_cirurgia 	= nr_cirurgia_p
	and	(dt_inicio_real IS NOT NULL AND dt_inicio_real::text <> '');
	
	if (dt_evento_p IS NOT NULL AND dt_evento_p::text <> '') and (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
		begin
		CALL gerar_evento_cirurgia_anest(	dt_evento_p,
						nr_cirurgia_p,
						nr_seq_evento_p,
						nm_usuario_p,
						null); --3 nr_seq_pepo
		end;
	end if;
	end;
elsif (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') then
	begin
	select	count(*)
	into STRICT	qt_cirurgia_w
	from	cirurgia
	where	nr_seq_pepo = nr_seq_pepo_p
	and	(dt_inicio_real IS NOT NULL AND dt_inicio_real::text <> '');
	end;
end if;

if (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') then --4
	begin
	select	coalesce(max(ie_executa_procedimentos),'N'),
		coalesce(max(ie_consiste_disp),'N'),
		coalesce(max(ie_gera_movimentacao),'N'),
		coalesce(max(ie_finaliza_movimentacao), 'N'),
		coalesce(max(ie_focar_prescricao),'N'),
		coalesce(max(ie_finaliza_equipamento), 'N'),
		coalesce(max(ie_aviso_dispensacao), 'N'),
		coalesce(max(ie_imprime_relatorio),'N'),
		coalesce(max(IE_FIM_TAXA_SALA_PORTE),'N')
	into STRICT	ie_executa_procedimentos_w,
		ie_consiste_disp_w,  --5
		ie_gera_movimentacao_w,
		ie_finaliza_movimentacao_w,
		ie_focar_prescricao_w,
		ie_finaliza_equipamento_w,
		ie_aviso_dispensacao_w,
		ie_imprime_relatorio_w,
		IE_FIM_TAXA_SALA_PORTE_w
	from 	evento_cirurgia
	where 	nr_sequencia = nr_seq_evento_p;
		
	if (qt_cirurgia_w			> 0) 	and (ie_executa_procedimentos_w	= 'S') 	then 
		begin
		realizar_proc_previstos_w 	:= 'S';
		end;
	end if;
	
	if (ie_finaliza_equipamento_w 	= 'S') and (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then
		begin
		dt_evento_w := obter_data_fim_equip(nr_cirurgia_p);
		CALL finaliza_evento_cirurgia(nr_cirurgia_p, dt_evento_w);
		end;
	end if;
	
	end;
end if;

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	begin
	ie_atendimento_disp_w := obter_se_atendimento_disp(nr_atendimento_p); --6
	end;
end if;

if (dt_inicio_prevista_w IS NOT NULL AND dt_inicio_prevista_w::text <> '') and (dt_evento_p IS NOT NULL AND dt_evento_p::text <> '') then
	begin
	qt_tempo_min_w := obter_min_entre_datas(dt_inicio_prevista_w, dt_evento_p, 1);
	end;
end if;

if (ie_aviso_dispensacao_w	= 'S') and (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	CALL gerar_resumo_agente(nr_cirurgia_p, nm_usuario_p, nr_atendimento_p,nr_seq_pepo_p);
	
	if (ie_cirurgia_p IS NOT NULL AND ie_cirurgia_p::text <> '') and (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '') then
		begin
		select	count(*)
		into STRICT	qt_resumo_agente_w
		from	w_resumo_agente
		where	obter_se_disp_ajustada(nr_cirurgia, cd_material) = 'N'
		and	((ie_cirurgia_p = 'S' AND nr_cirurgia = nr_cirurgia_p)
		or	 (ie_cirurgia_p = 'N' AND nr_seq_pepo = nr_seq_pepo_p));
		end;
	end if;

	end;
end if;

if ((ie_fim_taxa_sala_porte_w = 'S') and (coalesce(ie_gera_taxa_porte_w, 'S') = 'N') and (coalesce(ie_java_html_p, 'N') = 'S')) then
	CALL gerar_taxa_porte_evento(nr_cirurgia_p, nr_atendimento_p, nm_usuario_p);
end if;

dados_evento_cirurgia_p		:= dados_evento_cirurgia_w;
ie_status_cirurgia_p		:= ie_status_cirurgia_w;
realizar_proc_previstos_p	:= realizar_proc_previstos_w;
ie_consiste_disp_p		:= ie_consiste_disp_w; --5
ie_atendimento_disp_p		:= ie_atendimento_disp_w; --6
ie_gera_movimentacao_p		:= ie_gera_movimentacao_w;
ie_finaliza_movimentacao_p	:= ie_finaliza_movimentacao_w;
ie_focar_prescricao_p		:= ie_focar_prescricao_w;
dt_inicio_prevista_p		:= dt_inicio_prevista_w;
qt_tempo_min_p			:= qt_tempo_min_w;
qt_resumo_agente_p		:= qt_resumo_agente_w;
ie_executa_procedimentos_p	:= ie_executa_procedimentos_w;
ie_imprime_relatorio_p		:= ie_imprime_relatorio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE executar_acoes_evento ( nr_sequencia_p bigint, ie_opcao_p text, nr_cirurgia_p bigint, dt_evento_p timestamp, nr_seq_evento_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint, nr_atendimento_p bigint, ie_cirurgia_p text, dados_evento_cirurgia_p INOUT text, ie_status_cirurgia_p INOUT text, realizar_proc_previstos_p INOUT text, ie_consiste_disp_p INOUT text, ie_atendimento_disp_p INOUT text, ie_gera_movimentacao_p INOUT text, ie_finaliza_movimentacao_p INOUT text, ie_focar_prescricao_p INOUT text, ie_executa_procedimentos_p INOUT text, dt_inicio_prevista_p INOUT timestamp, qt_tempo_min_p INOUT bigint, qt_resumo_agente_p INOUT bigint, ie_imprime_relatorio_p INOUT text, ie_java_html_p text default 'N') FROM PUBLIC;

