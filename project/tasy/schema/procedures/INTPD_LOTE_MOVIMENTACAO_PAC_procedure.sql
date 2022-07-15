-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_lote_movimentacao_pac ( nr_atendimento_p bigint, cd_setor_new_p bigint, cd_setor_old_p bigint, nr_opcao_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
NR_OPCAO_P

1 - Transferencia
2 - Alta
3 - Internacao - Opcao nao tratada nesta procedure
4 - Atualizacao setor
*/
reg_integracao_p			gerar_int_padrao.reg_integracao;
ie_setor_new_emp_wms_w		varchar(1) := 'N';
ie_setor_old_emp_wms_w		varchar(1) := 'N';
ie_prescr_vigente_w		varchar(1) := 'N';
nr_seq_empresa_w			empresa_integracao.nr_sequencia%type;
nr_prescricao_w			prescr_medica.nr_prescricao%type;
cd_estabelecimento_w		prescr_medica.cd_estabelecimento%type;
cd_local_estoque_w		ap_lote.cd_local_estoque%type;
nr_seq_lote_w			ap_lote.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		cd_local_estoque
	from	ap_lote
	where	nr_prescricao = nr_prescricao_w
	and	coalesce(dt_atend_farmacia::text, '') = '';

c02 CURSOR FOR
	SELECT	a.nr_prescricao,
		a.cd_estabelecimento
	from	prescr_medica a,
		prescr_mat_hor b
	where	(b.nr_seq_lote IS NOT NULL AND b.nr_seq_lote::text <> '')
	and	a.dt_validade_prescr > clock_timestamp()
	and	obter_status_processo(b.nr_seq_processo) in ('G','X')
	and exists ( SELECT 1 from ap_lote x where x.nr_sequencia = b.nr_seq_lote and coalesce(x.dt_atend_farmacia::text, '') = '')
	and	b.qt_dispensar_hor > 0
	and	a.cd_setor_atendimento = cd_setor_old_p
	and	a.nr_atendimento = nr_atendimento_p
	and	a.nr_prescricao = b.nr_prescricao
	group by a.nr_prescricao,
		a.cd_estabelecimento;

c03 CURSOR FOR
	SELECT	a.nr_prescricao,
		a.cd_estabelecimento
	from	prescr_medica a,
		prescr_mat_hor b
	where	(b.nr_seq_lote IS NOT NULL AND b.nr_seq_lote::text <> '')
	and	a.dt_validade_prescr > clock_timestamp()
	and	obter_status_processo(b.nr_seq_processo) in ('G','X')
	and exists ( SELECT 1 from ap_lote x where x.nr_sequencia = b.nr_seq_lote and coalesce(x.dt_atend_farmacia::text, '') = '')
	and	b.qt_dispensar_hor > 0
	and	a.cd_setor_atendimento = cd_setor_new_p
	and	a.nr_atendimento = nr_atendimento_p
	and	a.nr_prescricao = b.nr_prescricao
	group by a.nr_prescricao,
		a.cd_estabelecimento;


BEGIN
begin
select	nr_sequencia
into STRICT	nr_seq_empresa_w
from	empresa_integracao
where	upper(nm_empresa) = 'BRINT'  LIMIT 1;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_setor_new_emp_wms_w
from	far_setores_integracao
where	nr_seq_empresa_int = nr_seq_empresa_w
and	cd_setor_atendimento = cd_setor_new_p  LIMIT 1;

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_setor_old_emp_wms_w
from	far_setores_integracao
where	nr_seq_empresa_int = nr_seq_empresa_w
and	cd_setor_atendimento = cd_setor_old_p  LIMIT 1;
exception
when others then
	nr_seq_empresa_w := 0;
	ie_setor_new_emp_wms_w := 'N';
	ie_setor_old_emp_wms_w := 'N';
end;

-- Opcao 4 > Gera prescricao no novo setor do paciente.
if (nr_opcao_p = 4) then -- Movimentacao > ATUALIZAR_SETOR_PRESCRICAO
	begin
	
	-- Setor WMS X Setor WMS
	if (ie_setor_old_emp_wms_w = 'S') and (ie_setor_new_emp_wms_w = 'S') then
		begin
		select	'S'
		into STRICT	ie_prescr_vigente_w
		from	prescr_medica a,
			prescr_mat_hor b
		where	(b.nr_seq_lote IS NOT NULL AND b.nr_seq_lote::text <> '')
		and	a.dt_validade_prescr > clock_timestamp()
		and	obter_status_processo(b.nr_seq_processo) in ('G','X')
		and exists ( SELECT 1 from ap_lote x where x.nr_sequencia = b.nr_seq_lote and coalesce(x.dt_atend_farmacia::text, '') = '')
		and	b.qt_dispensar_hor > 0
		and	a.cd_setor_atendimento = cd_setor_new_p
		and	a.nr_atendimento = nr_atendimento_p
		and	a.nr_prescricao = b.nr_prescricao  LIMIT 1;
		exception
		when others then
			ie_prescr_vigente_w := 'N';
		end;
		
		if (ie_prescr_vigente_w = 'S') then
			open c03;
			loop
			fetch c03 into	
				nr_prescricao_w,
				cd_estabelecimento_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
				
				/* Seleciona os lotes da prescricao que nao possuem data de atendimento da farmacia,
				envia os lotes para integracao no novo setor de atendimento
				e para cancelamento no setor de atendimento anterior. */
				open c01;
				loop
				fetch c01 into	
					nr_seq_lote_w,
					cd_local_estoque_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					begin
					reg_integracao_p.cd_estab_documento	:= cd_estabelecimento_w;
					reg_integracao_p.cd_local_estoque	:= cd_local_estoque_w;
					reg_integracao_p.nr_seq_agrupador	:= nr_seq_lote_w;
					
					/* Setor de atendimento onde serao cancelados os lotes na integracao */

					reg_integracao_p.cd_setor_atendimento	:= cd_setor_old_p;
					
					/* Enviar cancelamento item lote */

					reg_integracao_p := gerar_int_padrao.gravar_integracao('275', nr_seq_lote_w, nm_usuario_p, reg_integracao_p);
					
					
					
					/* Setor de atendimento onde serao gerados os lotes na integracao*/

					reg_integracao_p.cd_setor_atendimento	:= cd_setor_new_p;
					
					/* Enviar lote prescricao */

					reg_integracao_p := gerar_int_padrao.gravar_integracao('260', nr_seq_lote_w, nm_usuario_p, reg_integracao_p);
					end;
				end loop;
				close c01;
				
				end;
			end loop;
			close c03;
		end if;
	end if;
	-- Setor WMS X Setor WMS

	
	-- Nao Setor WMS X Setor WMS
	if (ie_setor_old_emp_wms_w = 'N') and (ie_setor_new_emp_wms_w = 'S') then
		begin
		select	'S'
		into STRICT	ie_prescr_vigente_w
		from	prescr_medica a,
			prescr_mat_hor b
		where	(b.nr_seq_lote IS NOT NULL AND b.nr_seq_lote::text <> '')
		and	a.dt_validade_prescr > clock_timestamp()
		and	obter_status_processo(b.nr_seq_processo) in ('G','X')
		and exists ( SELECT 1 from ap_lote x where x.nr_sequencia = b.nr_seq_lote and coalesce(x.dt_atend_farmacia::text, '') = '')
		and	b.qt_dispensar_hor > 0
		and	a.cd_setor_atendimento = cd_setor_new_p
		and	a.nr_atendimento = nr_atendimento_p
		and	a.nr_prescricao = b.nr_prescricao  LIMIT 1;
		exception
		when others then
			ie_prescr_vigente_w := 'N';
		end;
		
		if (ie_prescr_vigente_w = 'S') then
			open c03;
			loop
			fetch c03 into
				nr_prescricao_w,
				cd_estabelecimento_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
				begin
				
				/* Seleciona os lotes da prescricao que nao possuem data de atendimento da farmacia
				e envia os lotes para integracao no novo setor de atendimento. */
				open c01;
				loop
				fetch c01 into	
					nr_seq_lote_w,
					cd_local_estoque_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					begin
					reg_integracao_p.cd_estab_documento	:= cd_estabelecimento_w;
					reg_integracao_p.cd_local_estoque	:= cd_local_estoque_w;
					reg_integracao_p.nr_seq_agrupador	:= nr_seq_lote_w;
					
					/* Setor de atendimento onde serao gerados os lotes na integracao */

					reg_integracao_p.cd_setor_atendimento	:= cd_setor_new_p;
					
					/* Enviar lote prescricao */

					reg_integracao_p := gerar_int_padrao.gravar_integracao('260', nr_seq_lote_w, nm_usuario_p, reg_integracao_p);
					end;
				end loop;
				close c01;
				
				end;
			end loop;
			close c03;
		end if;
	end if;
	-- Nao Setor WMS X Setor WMS
	end;
	
-- Opcao 1 > Gera cancelamento das prescricoes no antigo setor do paciente.
elsif (nr_opcao_p = 1) then -- Movimentacao > GERAR_TRANSFERENCIA_PACIENTE
	begin
	
	-- Setor WMS X Nao Setor WMS
	if (ie_setor_old_emp_wms_w = 'S') and (ie_setor_new_emp_wms_w = 'N') then
		begin
		select	'S'
		into STRICT	ie_prescr_vigente_w
		from	prescr_medica a,
			prescr_mat_hor b
		where	(b.nr_seq_lote IS NOT NULL AND b.nr_seq_lote::text <> '')
		and	a.dt_validade_prescr > clock_timestamp()
		and	obter_status_processo(b.nr_seq_processo) in ('G','X')
		and exists ( SELECT 1 from ap_lote x where x.nr_sequencia = b.nr_seq_lote and coalesce(x.dt_atend_farmacia::text, '') = '')
		and	b.qt_dispensar_hor > 0
		and	a.cd_setor_atendimento = cd_setor_old_p
		and	a.nr_atendimento = nr_atendimento_p
		and	a.nr_prescricao = b.nr_prescricao  LIMIT 1;
		exception
		when others then
			ie_prescr_vigente_w := 'N';
		end;
		
		if (ie_prescr_vigente_w = 'S') then
			open c02;
			loop
			fetch c02 into	
				nr_prescricao_w,
				cd_estabelecimento_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				
				/* Seleciona os lotes da prescricao que nao possuem data de atendimento da farmacia
				e envia os lotes para integracao para cancelamento no setor de atendimento anterior. */
				open c01;
				loop
				fetch c01 into	
					nr_seq_lote_w,
					cd_local_estoque_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					begin
					reg_integracao_p.cd_estab_documento	:= cd_estabelecimento_w;
					reg_integracao_p.cd_local_estoque	:= cd_local_estoque_w;
					reg_integracao_p.nr_seq_agrupador	:= nr_seq_lote_w;
					
					/* Setor de atendimento onde serao cancelados os lotes na integracao */

					reg_integracao_p.cd_setor_atendimento	:= cd_setor_old_p;
					
					/* Enviar cancelamento item lote */

					reg_integracao_p := gerar_int_padrao.gravar_integracao('275', nr_seq_lote_w, nm_usuario_p, reg_integracao_p);
					end;
				end loop;
				close c01;
				
				end;
			end loop;
			close c02;
		end if;
	end if;
	-- Setor WMS X Nao Setor WMS

	
	-- Setor WMS X Setor WMS
	if (ie_setor_old_emp_wms_w = 'S') and (ie_setor_new_emp_wms_w = 'S') then
		begin
		select	'S'
		into STRICT	ie_prescr_vigente_w
		from	prescr_medica a,
			prescr_mat_hor b
		where	(b.nr_seq_lote IS NOT NULL AND b.nr_seq_lote::text <> '')
		and	a.dt_validade_prescr > clock_timestamp()
		and	obter_status_processo(b.nr_seq_processo) in ('G','X')
		and exists ( SELECT 1 from ap_lote x where x.nr_sequencia = b.nr_seq_lote and coalesce(x.dt_atend_farmacia::text, '') = '')
		and	b.qt_dispensar_hor > 0
		and	a.cd_setor_atendimento = cd_setor_old_p
		and	a.nr_atendimento = nr_atendimento_p
		and	a.nr_prescricao = b.nr_prescricao  LIMIT 1;
		exception
		when others then
			ie_prescr_vigente_w := 'N';
		end;
		
		if (ie_prescr_vigente_w = 'S') then
			open c02;
			loop
			fetch c02 into	
				nr_prescricao_w,
				cd_estabelecimento_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				
				/* Seleciona os lotes da prescricao que nao possuem data de atendimento da farmacia,
				envia os lotes para integracao no novo setor de atendimento
				e para cancelamento no setor de atendimento anterior. */
				open c01;
				loop
				fetch c01 into	
					nr_seq_lote_w,
					cd_local_estoque_w;
				EXIT WHEN NOT FOUND; /* apply on c01 */
					begin
					reg_integracao_p.cd_estab_documento	:= cd_estabelecimento_w;
					reg_integracao_p.cd_local_estoque	:= cd_local_estoque_w;
					reg_integracao_p.nr_seq_agrupador	:= nr_seq_lote_w;
					
					/* Setor de atendimento onde serao cancelados os lotes na integracao */

					reg_integracao_p.cd_setor_atendimento	:= cd_setor_old_p;
					
					/* Enviar cancelamento item lote */

					reg_integracao_p := gerar_int_padrao.gravar_integracao('275', nr_seq_lote_w, nm_usuario_p, reg_integracao_p);
					
					
					
					/* Setor de atendimento onde serao gerados os lotes na integracao */

					reg_integracao_p.cd_setor_atendimento	:= cd_setor_new_p;
					
					/* Enviar lote prescricao */

					reg_integracao_p := gerar_int_padrao.gravar_integracao('260', nr_seq_lote_w, nm_usuario_p, reg_integracao_p);
					end;
				end loop;
				close c01;
				
				end;
			end loop;
			close c02;
		end if;
	end if;
	-- Setor WMS X Setor WMS
	end;
	
-- Opcao 2 > Gera alta do paciente na integracao.
elsif (nr_opcao_p = 2) and (ie_setor_old_emp_wms_w = 'S') then -- Alta > GERAR_ESTORNAR_ALTA
	begin
	select	'S'
	into STRICT	ie_prescr_vigente_w
	from	prescr_medica a,
		prescr_mat_hor b
	where	(b.nr_seq_lote IS NOT NULL AND b.nr_seq_lote::text <> '')
	and	a.dt_validade_prescr > clock_timestamp()
	and	obter_status_processo(b.nr_seq_processo) in ('G','X')
	and exists ( SELECT 1 from ap_lote x where x.nr_sequencia = b.nr_seq_lote and coalesce(x.dt_atend_farmacia::text, '') = '')
	and	b.qt_dispensar_hor > 0
	and	a.cd_setor_atendimento = cd_setor_old_p
	and	a.nr_atendimento = nr_atendimento_p
	and	a.nr_prescricao = b.nr_prescricao  LIMIT 1;
	exception
	when others then
		ie_prescr_vigente_w := 'N';
	end;
	
	if (ie_prescr_vigente_w = 'S') then
		open c02;
		loop
		fetch c02 into	
			nr_prescricao_w,
			cd_estabelecimento_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			
			/* Seleciona os lotes da prescricao que nao possuem data de atendimento da farmacia
			e envia os lotes para integracao para cancelamento no setor de atendimento anterior. */
			open c01;
			loop
			fetch c01 into	
				nr_seq_lote_w,
				cd_local_estoque_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				reg_integracao_p.cd_estab_documento	:= cd_estabelecimento_w;
				reg_integracao_p.cd_local_estoque	:= cd_local_estoque_w;
				reg_integracao_p.nr_seq_agrupador	:= nr_seq_lote_w;
				
				/* Setor de atendimento onde serao cancelados os lotes na integracao */

				reg_integracao_p.cd_setor_atendimento	:= cd_setor_old_p;
				
				/* Enviar cancelamento item lote */

				reg_integracao_p := gerar_int_padrao.gravar_integracao('275', nr_seq_lote_w, nm_usuario_p, reg_integracao_p);
				end;
			end loop;
			close c01;
			
			end;
		end loop;
		close c02;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_lote_movimentacao_pac ( nr_atendimento_p bigint, cd_setor_new_p bigint, cd_setor_old_p bigint, nr_opcao_p bigint, nm_usuario_p text) FROM PUBLIC;

