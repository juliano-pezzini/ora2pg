-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function atualizar_tx_orcamento_pacote as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE atualizar_tx_orcamento_pacote (nr_seq_orc_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL atualizar_tx_orcamento_pacote_atx ( ' || quote_nullable(nr_seq_orc_p) || ',' || quote_nullable(nr_sequencia_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE atualizar_tx_orcamento_pacote_atx (nr_seq_orc_p bigint, nr_sequencia_p bigint) AS $body$
DECLARE

	
nr_sequencia_w			orcamento_paciente_proc.nr_sequencia%type;
vl_pacote_w			orcamento_paciente_proc.vl_procedimento%type;
vl_original_w			orcamento_paciente_proc.vl_procedimento%type;
nr_pacote_maior_valor_w		orcamento_paciente_proc.nr_sequencia%type;
nr_pacote_seg_maior_valor_w	orcamento_paciente_proc.nr_sequencia%type;
vl_pacote_maior_valor_w		orcamento_paciente_proc.vl_procedimento%type;
tx_pacote_maior_w		regra_tx_pacote.tx_pacote_maior%type;
tx_pacote_seg_maior_w		regra_tx_pacote.tx_pacote_seg_maior%type;
tx_pacote_demais_w		regra_tx_pacote.tx_pacote_demais%type;
cd_convenio_w			orcamento_paciente.cd_convenio%type;
qt_regra_tx_w			bigint;
cd_estabelecimento_w		orcamento_paciente.cd_estabelecimento%type;
ie_achou_w			varchar(1):= 'N';
vl_pacote_seg_maior_valor_w	double precision;
cd_procedimento_w		orcamento_paciente_proc.cd_procedimento%type;
ie_origem_proced_w		orcamento_paciente_proc.ie_origem_proced%type;
nr_seq_proc_interno_ww		orcamento_paciente_proc.nr_seq_proc_interno%type;
ie_via_acesso_w			orcamento_paciente_proc.ie_via_acesso%type;
ie_diferente_w			varchar(1):= 'N';
ie_regra_geral_w		regra_tx_pacote.ie_regra_geral%type;
cd_area_procedimento_w		estrutura_procedimento_v.cd_area_procedimento%type;
cd_especialidade_proc_w		estrutura_procedimento_v.cd_especialidade%type;
cd_grupo_proc_w			estrutura_procedimento_v.cd_grupo_proc%type;
qt_proc_regra_w			bigint;
nr_seq_regra_tx_w		regra_tx_pacote.nr_sequencia%type;
qt_regra_ww			bigint;					

/* TRATAMENTO CURSORES DEFINE_PACOTE_PROCEDIMENTO  */

c12 CURSOR FOR
	SELECT  coalesce(tx_pacote_maior,100),
		coalesce(tx_pacote_demais,100),
		coalesce(ie_regra_geral,'N'),
		coalesce(nr_sequencia,0),
		tx_pacote_seg_maior
	from 	regra_tx_pacote
	where	cd_convenio = cd_convenio_w
	and 	ie_achou_w = 'N'
	and 	coalesce(IE_REGRA_VIA_ACESSO,'N') = 'N'
	and	coalesce(cd_estabelecimento,  wheb_usuario_pck.get_cd_estabelecimento) =  wheb_usuario_pck.get_cd_estabelecimento
	order by coalesce(ie_regra_geral,'N');

c13 CURSOR FOR
	SELECT 	a.nr_sequencia,		
		a.vl_procedimento,		
		a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_seq_proc_interno,
		coalesce(a.IE_VIA_ACESSO,'U'),		
		dividir((a.vl_procedimento * 100), coalesce(a.tx_procedimento, 100)) vl_original
	from 	orcamento_paciente_proc a
	where 	a.NR_SEQUENCIA_ORCAMENTO = nr_seq_orc_p
	and 	a.ie_pacote = 'S'
	and	a.nr_sequencia	!= coalesce(nr_sequencia_p, 0)
	order by vl_original desc, nr_sequencia asc;

c14 CURSOR FOR
	SELECT  coalesce(tx_pacote_maior,100),
		coalesce(tx_pacote_demais,100),
		coalesce(ie_regra_geral,'N'),
		coalesce(nr_sequencia,0),
		tx_pacote_seg_maior
	from 	regra_tx_pacote
	where	cd_convenio = cd_convenio_w
	and 	coalesce(IE_REGRA_VIA_ACESSO,'N') = ie_diferente_w
	and	coalesce(cd_estabelecimento,  wheb_usuario_pck.get_cd_estabelecimento) =  wheb_usuario_pck.get_cd_estabelecimento
	order by coalesce(ie_regra_geral,'N');

/* FIM TRATAMENTO CURSORES DEFINE_PACOTE_PROCEDIMENTO */

BEGIN	
	
	select	max(cd_estabelecimento),
		max(cd_convenio)
	into STRICT	cd_estabelecimento_w,
		cd_convenio_w
	from	orcamento_paciente
	where	nr_sequencia_orcamento = nr_seq_orc_p;

	-- Regra % Pacote Cirurgia independente de Cirurgia (Vale para todos os pacote)  // Verifica a Estrutura
	select 	count(*)
	into STRICT	qt_regra_tx_w
	from 	regra_tx_pacote
	where 	cd_convenio = cd_convenio_w
	and	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_w,1)) = coalesce(cd_estabelecimento_w,1)
	and 	coalesce(IE_REGRA_VIA_ACESSO,'N') = 'N';

	if (qt_regra_tx_w > 0) then

		-- os 233888
		ie_achou_w:= 'N';
		vl_pacote_maior_valor_w	:= 0;
		nr_pacote_maior_valor_w	:= 0;
		nr_pacote_seg_maior_valor_w:= 0;
		vl_pacote_seg_maior_valor_w:= 0;

		open C12;
		loop
		fetch C12 into
			tx_pacote_maior_w,
			tx_pacote_demais_w,
			ie_regra_geral_w,
			nr_seq_regra_tx_w,
			tx_pacote_seg_maior_w;
		EXIT WHEN NOT FOUND; /* apply on C12 */
			begin
			
			open c13;
			loop
			fetch c13 into
				nr_sequencia_w,
				vl_pacote_w,
				cd_procedimento_w,
				IE_ORIGEM_PROCED_w,
				NR_SEQ_PROC_INTERNO_ww,
				ie_via_acesso_w,
				vl_original_w;
			EXIT WHEN NOT FOUND; /* apply on c13 */
				begin
				select 	max(cd_area_procedimento),
					max(cd_especialidade),
					max(cd_grupo_proc)
				into STRICT	cd_area_procedimento_w,
					cd_especialidade_proc_w,
					cd_grupo_proc_w
				from 	estrutura_procedimento_v
				where	cd_procedimento = cd_procedimento_w
				and 	ie_origem_proced = ie_origem_proced_w;

				select 	count(*)
				into STRICT	qt_proc_regra_w
				from 	regra_tx_pacote_item
				where 	nr_seq_regra_tx = nr_seq_regra_tx_w
				and 	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0)
				and 	coalesce(cd_especialidade, coalesce(cd_especialidade_proc_w,0)) = coalesce(cd_especialidade_proc_w,0)
				and 	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_w,0)) = coalesce(cd_grupo_proc_w,0)
				and	coalesce(cd_procedimento, coalesce(cd_procedimento_w,0)) = coalesce(cd_procedimento_w,0)
				and 	((coalesce(cd_procedimento,0) = 0) or (coalesce(ie_origem_proced, coalesce(ie_origem_proced_w,0)) = coalesce(ie_origem_proced_w,0)))
				and 	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_ww, 0)) = coalesce(nr_seq_proc_interno_ww, 0);

				if (qt_proc_regra_w > 0) then
					ie_achou_w:= 'S';
					exit;
				end if;

				end;
			end loop;
			close c13;

			if (ie_achou_w = 'S') then
				exit;
			end if;
			--OS 359619
			end;
		end loop;
		close C12;
		
		commit;
		-- Quando chegar aqui o sistema j?ncontrou a regra
		open c13;
		loop
		fetch c13 into
			nr_sequencia_w,
			vl_pacote_w,		
			cd_procedimento_w,
			ie_origem_proced_w,
			nr_seq_proc_interno_ww,
			ie_via_acesso_w,
			vl_original_w;
		EXIT WHEN NOT FOUND; /* apply on c13 */
			begin				
				if (nr_pacote_maior_valor_w = 0) then			
					nr_pacote_maior_valor_w	:= nr_sequencia_w;
					vl_pacote_maior_valor_w	:= vl_pacote_w;
					update	orcamento_paciente_proc
					set 	TX_PROCEDIMENTO	= coalesce(tx_pacote_maior_w,TX_PROCEDIMENTO),
						vl_procedimento	= vl_original_w
					where 	nr_sequencia 	= nr_sequencia_w;
				else
					if (tx_pacote_seg_maior_w IS NOT NULL AND tx_pacote_seg_maior_w::text <> '') and (nr_pacote_seg_maior_valor_w = 0) then
						nr_pacote_seg_maior_valor_w	:= nr_sequencia_w;
						update	orcamento_paciente_proc
						set 	TX_PROCEDIMENTO	= coalesce(tx_pacote_seg_maior_w,TX_PROCEDIMENTO),
							vl_procedimento	= dividir((vl_original_w * tx_pacote_seg_maior_w), 100)
						where 	nr_sequencia 	= nr_sequencia_w;
					else
						update	orcamento_paciente_proc
						set 	TX_PROCEDIMENTO	= coalesce(tx_pacote_demais_w,TX_PROCEDIMENTO),
							vl_procedimento	= dividir((vl_original_w * tx_pacote_demais_w), 100)
						where 	nr_sequencia 	= nr_sequencia_w;
					end if;
				end if;				
			end;
		end loop;
		close c13;

	end if;

	-- Regra % Pacote Cirurgia independente de Cirurgia (Vale para todos os pacote)  // Via de acesso
	select 	count(*)
	into STRICT	qt_regra_tx_w
	from 	regra_tx_pacote
	where 	cd_convenio = cd_convenio_w
	and 	coalesce(IE_REGRA_VIA_ACESSO,'N') <> 'N';

	if (qt_regra_tx_w > 0) then

		-- os 259856
		vl_pacote_maior_valor_w	:= 0;
		nr_pacote_maior_valor_w	:= 0;
		nr_pacote_seg_maior_valor_w:= 0;
		vl_pacote_seg_maior_valor_w:= 0;

		--Aplicar o %
		open c13;
		loop
		fetch c13 into
			nr_sequencia_w,
			vl_pacote_w,		
			cd_procedimento_w,
			ie_origem_proced_w,
			nr_seq_proc_interno_ww,
			ie_via_acesso_w,
			vl_original_w;
		EXIT WHEN NOT FOUND; /* apply on c13 */
			begin

			if	((ie_via_acesso_w = 'M') or (ie_via_acesso_w = 'U')) then -- Mesma via ou ?ica ou principal
				ie_diferente_w		:= 'M'; -- 'M' Mesma Via	-- 'D' Vias diferentes
			elsif	((ie_via_acesso_w = 'B') or (ie_via_acesso_w = 'D')) then -- Bilateral ou via diferente
				ie_diferente_w		:= 'D'; -- 'M' Mesma Via	-- 'D' Vias diferentes
			end if;

			-- Buscar a regra correspondente
			open C14;
			loop
			fetch C14 into
				tx_pacote_maior_w,
				tx_pacote_demais_w,
				ie_regra_geral_w,
				nr_seq_regra_tx_w,
				tx_pacote_seg_maior_w;
			EXIT WHEN NOT FOUND; /* apply on C14 */
				begin
				tx_pacote_maior_w	:= tx_pacote_maior_w;
				tx_pacote_demais_w	:= tx_pacote_demais_w;
				ie_regra_geral_w	:= ie_regra_geral_w;
				nr_seq_regra_tx_w	:= nr_seq_regra_tx_w;
				tx_pacote_seg_maior_w	:= tx_pacote_seg_maior_w;
				end;
			end loop;
			close C14;

			select 	max(cd_area_procedimento),
				max(cd_especialidade),
				max(cd_grupo_proc)
			into STRICT	cd_area_procedimento_w,
				cd_especialidade_proc_w,
				cd_grupo_proc_w
			from 	estrutura_procedimento_v
			where	cd_procedimento = cd_procedimento_w
			and 	ie_origem_proced = ie_origem_proced_w;

			select 	count(*)
			into STRICT	qt_regra_ww
			from 	regra_tx_pacote_item;

			if (qt_regra_ww > 0) then

				select 	count(*)
				into STRICT	qt_proc_regra_w
				from 	regra_tx_pacote_item
				where 	nr_seq_regra_tx = nr_seq_regra_tx_w
				and 	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_w,0)) = coalesce(cd_area_procedimento_w,0)
				and 	coalesce(cd_especialidade, coalesce(cd_especialidade_proc_w,0)) = coalesce(cd_especialidade_proc_w,0)
				and 	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_w,0)) = coalesce(cd_grupo_proc_w,0)
				and	coalesce(cd_procedimento, coalesce(cd_procedimento_w,0)) = coalesce(cd_procedimento_w,0)
				and 	((coalesce(cd_procedimento,0) = 0) or (coalesce(ie_origem_proced, coalesce(ie_origem_proced_w,0)) = coalesce(ie_origem_proced_w,0)))
				and 	coalesce(nr_seq_proc_interno, coalesce(nr_seq_proc_interno_ww, 0)) = coalesce(nr_seq_proc_interno_ww, 0);

			end if;
			-- Consistir estrutura OS 293503  FINAL
			if	((qt_regra_ww = 0) or (qt_proc_regra_w > 0)) then

				if (nr_pacote_maior_valor_w = 0) then

					nr_pacote_maior_valor_w	:= nr_sequencia_w;
					vl_pacote_maior_valor_w	:= vl_pacote_w;

					update	orcamento_paciente_proc
					set 	TX_PROCEDIMENTO	= coalesce(tx_pacote_maior_w,TX_PROCEDIMENTO),
						vl_procedimento	= vl_original_w
					where 	nr_sequencia 	= nr_sequencia_w;

				else

					if (tx_pacote_seg_maior_w IS NOT NULL AND tx_pacote_seg_maior_w::text <> '') and (nr_pacote_seg_maior_valor_w = 0) then
						nr_pacote_seg_maior_valor_w	:= nr_sequencia_w;
						vl_pacote_seg_maior_valor_w	:= vl_pacote_w;

						update	orcamento_paciente_proc
						set 	TX_PROCEDIMENTO	= coalesce(tx_pacote_seg_maior_w,TX_PROCEDIMENTO),
							vl_procedimento	= dividir((vl_original_w * tx_pacote_seg_maior_w), 100)
						where 	nr_sequencia 	= nr_sequencia_w;

					else
						update	orcamento_paciente_proc
						set 	TX_PROCEDIMENTO = coalesce(tx_pacote_demais_w,TX_PROCEDIMENTO),
							vl_procedimento	= dividir((vl_original_w * tx_pacote_demais_w), 100)
						where 	nr_sequencia 	= nr_sequencia_w;
					end if;				
				end if;
			end if;

			end;
		end loop;
		close c13;

	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_tx_orcamento_pacote (nr_seq_orc_p bigint, nr_sequencia_p bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE atualizar_tx_orcamento_pacote_atx (nr_seq_orc_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
