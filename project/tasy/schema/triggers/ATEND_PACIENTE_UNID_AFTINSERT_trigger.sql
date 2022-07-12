-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS atend_paciente_unid_aftinsert ON atend_paciente_unidade CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_atend_paciente_unid_aftinsert() RETURNS trigger AS $BODY$
DECLARE

cd_classif_setor_w			setor_atendimento.cd_classif_setor%type;
QT_PAC_UNIDADE_w			smallint;
qt_em_unidade_w				smallint;
nr_seq_interno_unidade_w	bigint;
ie_integra_regul_w			regulacao_parametro.ie_integracao_ativa%type;
nr_seq_regulacao_w			regulacao_atendimento.nr_regulacao%type;
ie_internacao_w				varchar(1);
nr_externo_w				unidade_atendimento.nr_externo%type;
qt_reg_w					bigint;
ie_tipo_atend_w				smallint;
cd_classif_setor_cross_w 	bigint;
qt_conv_int_cross_w			bigint;
ie_operacao_w				varchar(1);
ie_cons_episodio_w			varchar(1);
dt_cancelamento_w			atendimento_paciente.dt_cancelamento%type;
dt_alta_w					atendimento_paciente.dt_alta%type;
nr_seq_episodio_w			atendimento_paciente.nr_seq_episodio%type;
nr_seq_tipo_admissao_fat_w	atendimento_paciente.nr_seq_tipo_admissao_fat%type;
cd_pessoa_fisica_w			atendimento_paciente.cd_pessoa_fisica%type;
dt_entrada_w				atendimento_paciente.dt_entrada%type;
nr_atendimento_mae_w		atendimento_paciente.nr_atendimento_mae%type;
qt_tempo_regra_w     		wl_regra_item.qt_tempo_regra%type;
qt_tempo_normal_w			wl_regra_item.qt_tempo_normal%type;
nr_seq_regra_w				wl_regra_item.nr_sequencia%type;
ie_escala_w					wl_regra_item.ie_escala%type;
ie_opcao_wl_w				wl_regra_item.ie_opcao_wl%type;
nm_tabela_w					vice_escala.nm_tabela%type;
cd_setor_atendimento_w		wl_perfil.cd_setor_atendimento%type;

c01 CURSOR FOR
	SELECT	coalesce(b.qt_tempo_regra, 0) qt_tempo_regra_w,
			coalesce(b.qt_tempo_normal, 0) qt_tempo_normal_w,
			coalesce(b.nr_sequencia, 0) nr_seq_regra_w,
			coalesce(b.ie_escala, '') ie_escala_w,
			b.ie_opcao_wl ie_opcao_wl_w,
			(SELECT	max(nm_tabela)
			from	vice_escala
			where	ie_escala = b.ie_escala) nm_tabela_w,
			c.cd_setor_atendimento cd_setor_atendimento_w
	from 	wl_regra_worklist a,
			wl_regra_item b,
			wl_regra_geracao c
	where	a.nr_sequencia = b.nr_seq_regra
	and		b.nr_sequencia = c.nr_seq_regra_item
	and		b.ie_situacao = 'A'
	and		c.cd_setor_atendimento is not null
	and		a.nr_seq_item = (	select	max(x.nr_sequencia)
								from	wl_item x
								where	x.nr_sequencia = a.nr_seq_item
								and		x.cd_categoria = 'S'
								and		x.ie_situacao = 'A');

c02 CURSOR FOR
  SELECT  coalesce(b.qt_tempo_regra, 0),
      coalesce(b.qt_tempo_normal, 0),
      coalesce(b.nr_sequencia, 0),
      coalesce(b.ie_escala, ''),
      b.ie_opcao_wl,
      (SELECT  max(nm_tabela)
      from  vice_escala
      where  ie_escala = b.ie_escala),
      (select max(cd_classif_setor) 
      from setor_atendimento 
      where cd_setor_atendimento = NEW.cd_setor_atendimento)
  FROM wl_regra_worklist a, wl_regra_item b
LEFT OUTER JOIN wl_regra_geracao c ON (b.nr_sequencia = c.nr_seq_regra_item)
WHERE a.nr_sequencia = b.nr_seq_regra  and b.ie_situacao = 'A' and c.cd_setor_atendimento is null and a.nr_seq_item = (  select  max(x.nr_sequencia)
                from  wl_item x
                where  x.nr_sequencia = a.nr_seq_item
                and    x.cd_categoria = 'S'
                and    x.ie_situacao = 'A');
BEGIN
  BEGIN

cd_classif_setor_cross_w := obter_classif_setor_cross(NEW.cd_setor_atendimento);
qt_conv_int_cross_w := obter_conv_int_cross(NEW.nr_atendimento);

if (NEW.dt_saida_unidade is null) then
	select 	max(cd_classif_setor)
	into STRICT	cd_classif_setor_w
	from	setor_atendimento
	where	cd_setor_atendimento = NEW.cd_setor_atendimento;

	if (cd_classif_setor_w in ('1','5')) then

		select	max(nr_seq_interno)
		into STRICT	nr_seq_interno_unidade_w
		from 	unidade_atendimento a
		WHERE 	A.cd_unidade_basica 	= NEW.cd_unidade_basica
		AND 	A.cd_unidade_compl  	= NEW.cd_unidade_compl
		AND 	A.cd_setor_atendimento 	= NEW.cd_setor_atendimento;

		insert into controle_atend_unidade(	nr_sequencia,
							nr_atendimento,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_interno,
							nr_seq_atepacu,
							dt_entrada)
					values (	nextval('controle_atend_unidade_seq'),
							NEW.nr_atendimento,
							LOCALTIMESTAMP,
							NEW.nm_usuario,
							LOCALTIMESTAMP,
							NEW.nm_usuario,
							nr_seq_interno_unidade_w,
							NEW.NR_SEQ_INTERNO,
							LOCALTIMESTAMP);

	end if;

end if;

select	coalesce(max(ie_integracao_ativa),'N')
into STRICT	ie_integra_regul_w
from	regulacao_parametro;

if (ie_integra_regul_w = 'S') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_regulacao_w
	from	regulacao_atendimento
	where	nr_atendimento	= NEW.nr_atendimento;

	if (coalesce(nr_seq_regulacao_w,0) > 0) then
		CALL reg_movimentar_paciente(nr_seq_regulacao_w, NEW.nr_atendimento,NEW.nm_usuario);
	end if;
end if;

select	coalesce(NR_EXTERNO,0)
into STRICT	nr_externo_w
from	unidade_atendimento
where	CD_UNIDADE_BASICA = NEW.CD_UNIDADE_BASICA
and		CD_UNIDADE_COMPL = NEW.CD_UNIDADE_COMPL
and		cd_setor_atendimento = NEW.cd_setor_atendimento;

if (nr_externo_w is not null) and (cd_classif_setor_cross_w > 0) and (qt_conv_int_cross_w > 0) then --adicionado consistencia para verificar se existe regra na classificacao do setor do cross.
	
	select	max(ie_tipo_atendimento),
		max(nr_atendimento_mae)
	into STRICT	ie_tipo_atend_w,
		nr_atendimento_mae_w
	from	atendimento_Paciente
	where	nr_atendimento	= NEW.nr_atendimento;
	
	if (NEW.NR_SEQ_UNID_ANT is null) then
		-- Internacao


		select count(*)
		into STRICT 	qt_reg_w
		from 	diagnostico_doenca
		where 	nr_atendimento = NEW.nr_atendimento;
		
		if ((qt_reg_w > 0) or (nr_atendimento_mae_w is not null)) and (coalesce(ie_tipo_atend_w,0) = 1) then
			CALL gravar_integracao_cross(277, 'NR_ATENDIMENTO='|| NEW.nr_atendimento ||';CD_ESTABELECIMENTO='|| wheb_usuario_pck.get_cd_estabelecimento || ';');
		end if;
	else
		select coalesce(NR_EXTERNO, 0)
		into STRICT nr_externo_w
		from unidade_atendimento
		where nr_seq_interno = NEW.NR_SEQ_UNID_ANT;

		if (nr_externo_w is null) or (nr_atendimento_mae_w is not null) then
			-- Internacao

			select 	count(*)
			into STRICT 	qt_reg_w
			from 	diagnostico_doenca
			where 	nr_atendimento = NEW.nr_atendimento;

			if ((qt_reg_w > 0) or (nr_atendimento_mae_w is not null)) and (coalesce(ie_tipo_atend_w,0) = 1) then
				CALL gravar_integracao_cross(277, 'NR_ATENDIMENTO='|| NEW.nr_atendimento || ';CD_ESTABELECIMENTO='|| wheb_usuario_pck.get_cd_estabelecimento || ';');
			end if;
		else
			-- Movimentacao

			CALL gravar_integracao_cross(278, 'NR_ATENDIMENTO='|| NEW.nr_atendimento || ';NR_SEQ_INTERNO=' || NEW.nr_seq_interno || ';CD_ESTABELECIMENTO='|| wheb_usuario_pck.get_cd_estabelecimento || ';');
		end if;
	end if;
else
	if (NEW.NR_SEQ_UNID_ANT is not null) and (cd_classif_setor_cross_w > 0) and (qt_conv_int_cross_w > 0) then
		
		select 	coalesce(NR_EXTERNO, 0)
		into STRICT 	nr_externo_w
		from 	unidade_atendimento
		where 	nr_seq_interno = NEW.NR_SEQ_UNID_ANT;

		if (nr_externo_w is not null) then
			--Saida

			CALL gravar_integracao_cross(280, 'NR_ATENDIMENTO='|| NEW.nr_atendimento ||';NR_SEQ_INTERNO=' || NEW.nr_seq_interno ||';CD_ESTABELECIMENTO='|| wheb_usuario_pck.get_cd_estabelecimento || ';');
		end if;
	end if;
end if;

BEGIN
select	max(dt_cancelamento),
	max(dt_alta)
into STRICT	dt_cancelamento_w,
	dt_alta_w
from	atendimento_Paciente
where	nr_atendimento	= NEW.nr_atendimento;
exception
when others then
	dt_cancelamento_w 	:= null;
	dt_alta_w		:= null;
end;


if (obter_qtd_pac_atendunid_pragma(NEW.nr_atendimento) <= 0) then
	BEGIN
	ie_operacao_w := 'I';
	end;
else
	BEGIN
	ie_operacao_w := 'A';
	end;
end if;

select	count(*)
into STRICT	qt_reg_w
from	intpd_fila_transmissao
where	ie_evento = '214'
and	ie_status = 'P'
and	nr_seq_documento = NEW.nr_atendimento
and	coalesce(ie_controle_tag,'0') = '0';

if (qt_reg_w > 0) then
	update	intpd_fila_transmissao
	set	ie_controle_tag = '1'
	where	ie_evento = '214'
	and	ie_status = 'P'
	and	nr_seq_documento = NEW.nr_atendimento
	and	coalesce(ie_controle_tag,'0') = '0';
end if;

if (dt_alta_w is null) and (dt_cancelamento_w is null) then
	BEGIN

	CALL intpd_enviar_atendimento(NEW.nr_atendimento, ie_operacao_w, '1', NEW.nm_usuario);
	/*O parametro ie_controle_tag_p e usado para controlar se foi uma movimentacao de paciente.
		0 - Nao foi uma movimentacao
		1 - Foi uma movimentacao
	Neste caso, esta inserindo uma nova movimentacao, entao e 1 */

	end;
end if;

open c01;
loop
fetch c01 into
	qt_tempo_regra_w,
	qt_tempo_normal_w,
	nr_seq_regra_w,
	ie_escala_w,
	ie_opcao_wl_w,
	nm_tabela_w,
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN
	
	select	nr_seq_episodio,
			nr_seq_tipo_admissao_fat,
			cd_pessoa_fisica,
			dt_entrada
	into STRICT	nr_seq_episodio_w,
			nr_seq_tipo_admissao_fat_w,
			cd_pessoa_fisica_w,
			dt_entrada_w
	from 	atendimento_paciente
	where 	nr_atendimento = NEW.nr_atendimento;
	
	select	(CASE WHEN nr_atendimento_mae_w IS NOT NULL THEN 'N' ELSE 'S' END)
	into STRICT	ie_cons_episodio_w
	;
	
	if (obter_se_regra_geracao(nr_seq_regra_w,nr_seq_episodio_w, nr_seq_tipo_admissao_fat_w, NEW.cd_setor_atendimento) = 'S' and cd_setor_atendimento_w = NEW.cd_setor_atendimento) then
		-- Gera Tarefa na Task list para escalas e indices

		
		if (qt_tempo_normal_w > 0 and (ie_opcao_wl_w = 'A' or ie_opcao_wl_w = 'E')) then
			CALL wl_gerar_finalizar_tarefa('S','I',NEW.nr_atendimento,cd_pessoa_fisica_w,NEW.nm_usuario,NEW.dt_entrada_unidade+(qt_tempo_normal_w/24),'N',null,null,null,null,null,null,ie_escala_w,null,null,nr_seq_regra_w,null,null,null,null,null,nm_tabela_w,null,dt_entrada_w,nr_seq_episodio_w,null,null,null,null,ie_cons_episodio_w);
		elsif (qt_tempo_regra_w > 0 and ie_opcao_wl_w = 'D') then
			CALL wl_gerar_finalizar_tarefa('S','I',NEW.nr_atendimento,cd_pessoa_fisica_w,NEW.nm_usuario,NEW.dt_entrada_unidade+(qt_tempo_regra_w/24),'N',null,null,null,null,null,null,ie_escala_w,null,null,nr_seq_regra_w,null,null,null,null,null,nm_tabela_w,null,dt_entrada_w,nr_seq_episodio_w,null,null,null,null,ie_cons_episodio_w);
		end if;
	end if;
	end;
end loop;
close c01;

open c02;
loop
fetch c02 into
  qt_tempo_regra_w,
  qt_tempo_normal_w,
  nr_seq_regra_w,
  ie_escala_w,
  ie_opcao_wl_w,
  nm_tabela_w,
  cd_classif_setor_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

BEGIN

	select	nr_seq_episodio,
			nr_seq_tipo_admissao_fat,
			cd_pessoa_fisica,
			dt_entrada
	into STRICT	nr_seq_episodio_w,
			nr_seq_tipo_admissao_fat_w,
			cd_pessoa_fisica_w,
			dt_entrada_w
	from 	atendimento_paciente
	where 	nr_atendimento = NEW.nr_atendimento;

	select	(CASE WHEN nr_atendimento_mae_w IS NOT NULL THEN 'N' ELSE 'S' END)
	into STRICT	ie_cons_episodio_w
	;

    if (obter_se_regra_geracao(nr_seq_regra_w,null,null) = 'S') then
        -- Gera tarefa escalas e indices para entrada na UTI

        if (qt_tempo_normal_w > 0 and (ie_opcao_wl_w = 'F' or ie_opcao_wl_w = 'G') and cd_classif_setor_w = 4) then
            CALL wl_gerar_finalizar_tarefa('S','I',NEW.nr_atendimento,cd_pessoa_fisica_w,NEW.nm_usuario,NEW.dt_entrada_unidade+(qt_tempo_normal_w/24),'N',null,null,null,null,null,null,ie_escala_w,null,null,nr_seq_regra_w,null,null,null,null,null,nm_tabela_w,null,NEW.dt_entrada_unidade,nr_seq_episodio_w,null,null,null,null,ie_cons_episodio_w);
        end if;
    end if;
end;
end loop;
close c02;

  END;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_atend_paciente_unid_aftinsert() FROM PUBLIC;

CREATE TRIGGER atend_paciente_unid_aftinsert
	AFTER INSERT ON atend_paciente_unidade FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_atend_paciente_unid_aftinsert();

