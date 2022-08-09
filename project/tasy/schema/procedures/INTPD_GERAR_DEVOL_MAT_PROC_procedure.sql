-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_gerar_devol_mat_proc ( cd_material_p bigint, nr_seq_lote_fornec_p bigint, nr_atendimento_p bigint, nr_seq_matpaci_p bigint, nr_seq_propaci_p bigint, qt_devolucao_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w				intpd_devol_mat_proc.nr_sequencia%type;
nr_seq_mat_atend_w			material_atend_paciente.nr_sequencia%type;
nr_seq_original_w				intpd_devol_mat_proc.nr_seq_original%type;
qt_material_w				material_atend_paciente.qt_material%type;
qt_total_desejado_devolucao_w		intpd_devol_mat_proc.qt_devolucao%type;
qt_devolvido_material_w			intpd_devol_mat_proc.qt_devolucao%type;
qt_devolver_w				intpd_devol_mat_proc.qt_devolucao%type;
qt_disponivel_devolucao_w 			intpd_devol_mat_proc.qt_devolucao%type;
nr_atendimento_w				intpd_devol_mat_proc.nr_atendimento%type;
nr_sequencia_log_w		bigint;
ie_liberado_w			varchar(1) := 'N';

c01 CURSOR FOR	
	SELECT	a.nr_sequencia,
		a.nr_atendimento,
		a.qt_material,		
		(SELECT	coalesce(sum(qt_devolucao), 0) 
		from	intpd_devol_mat_proc 
		where	nr_seq_original = a.nr_sequencia
		and	(nr_seq_matpaci IS NOT NULL AND nr_seq_matpaci::text <> '')) qt_ja_devolvidos
	from 	material_atend_paciente a
	where 	a.cd_material = cd_material_p
	and 	a.nr_atendimento = nr_atendimento_p
	and		a.cd_setor_atendimento = cd_setor_atendimento_p
	--and	((a.nr_seq_lote_fornec = nr_seq_lote_fornec_p) or (nr_seq_lote_fornec_p is null))
	and 	a.qt_material > 0
	and 	a.qt_material - (
			select	coalesce(sum(qt_devolucao), 0) 
			from	intpd_devol_mat_proc 
			where	nr_seq_original = a.nr_sequencia
			and	(nr_seq_matpaci IS NOT NULL AND nr_seq_matpaci::text <> '')) > 0
	order by 1;


BEGIN

select nextval('log_gera_devol_mat_proc_seq')
into STRICT	nr_sequencia_log_w
;

insert into log_gera_devol_mat_proc(
	nr_sequencia,
	nm_usuario,
	dt_inicio)
values (nr_sequencia_log_w,
	nm_usuario_p,
	clock_timestamp());

commit;

while(ie_liberado_w <> 'S')  loop
	begin

	select 	coalesce(max('N'),'S')
	into STRICT 	ie_liberado_w
	from 	log_gera_devol_mat_proc
	where 	nr_sequencia < nr_sequencia_log_w
	and (dt_inicio +1/288) > clock_timestamp()
	and 	coalesce(dt_final::text, '') = '';

	end;
end loop;

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (qt_devolucao_p IS NOT NULL AND qt_devolucao_p::text <> '') then
	begin
	
	qt_total_desejado_devolucao_w := qt_devolucao_p * -1;
	
	if (qt_total_desejado_devolucao_w > 0) then
		begin
		
		select	coalesce(sum(x.qt_disponivel_devolucao),0)
		into STRICT	qt_disponivel_devolucao_w
		from	(	SELECT 	a.qt_material - (select	coalesce(sum(b.qt_devolucao), 0)
							from	intpd_devol_mat_proc   b
							where	b.nr_seq_original = a.nr_sequencia
							and	(nr_seq_matpaci IS NOT NULL AND nr_seq_matpaci::text <> '')) qt_disponivel_devolucao
			from 	material_atend_paciente a
			where 	a.cd_material = cd_material_p
			and 	a.nr_atendimento = nr_atendimento_p
			--and		((a.nr_seq_lote_fornec = nr_seq_lote_fornec_p) or (nr_seq_lote_fornec_p is null))
			and		a.cd_setor_atendimento = cd_setor_atendimento_p
			and 	a.qt_material > 0
			and 	a.qt_material - (
					SELECT	coalesce(sum(qt_devolucao), 0) 
					from	intpd_devol_mat_proc 
					where	nr_seq_original = a.nr_sequencia
					and	(nr_seq_matpaci IS NOT NULL AND nr_seq_matpaci::text <> '')) > 0) x;					
		

		if (qt_disponivel_devolucao_w > 0) and
			((qt_disponivel_devolucao_w - qt_total_desejado_devolucao_w) >= 0) then
			begin
				open c01;
				loop
				fetch c01 into	
					nr_seq_mat_atend_w,
					nr_atendimento_w,
					qt_material_w,					
					qt_devolvido_material_w;
				EXIT WHEN NOT FOUND or qt_total_desejado_devolucao_w = 0;  /* apply on c01 */
					begin
					if (qt_total_desejado_devolucao_w <= (qt_material_w - qt_devolvido_material_w)) then
						begin
						qt_devolver_w := qt_total_desejado_devolucao_w;
						end;
					else
						begin
						qt_devolver_w := (qt_material_w - qt_devolvido_material_w);
						end;
					end if;
					
					insert into intpd_devol_mat_proc(	
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_matpaci,	
						nr_seq_propaci,	
						nr_seq_original,
						qt_devolucao,
						dt_devolucao,
						nr_atendimento)
					values (	nextval('intpd_devol_mat_proc_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_matpaci_p,
						nr_seq_propaci_p,
						nr_seq_mat_atend_w,
						qt_devolver_w,
						clock_timestamp(),
						nr_atendimento_w);
					
					qt_total_desejado_devolucao_w := qt_total_desejado_devolucao_w - qt_devolver_w;
					end;
				end loop;
				close c01;
			end;
		end if;
		end;
	end if;
	end;
end if;

update  log_gera_devol_mat_proc
set 	dt_final = clock_timestamp()
where 	nr_sequencia = nr_sequencia_log_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_gerar_devol_mat_proc ( cd_material_p bigint, nr_seq_lote_fornec_p bigint, nr_atendimento_p bigint, nr_seq_matpaci_p bigint, nr_seq_propaci_p bigint, qt_devolucao_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
