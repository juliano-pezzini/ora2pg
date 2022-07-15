-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_proc_prescr_dispositivo ( nr_seq_disp_prot_p bigint, nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_protocolo_w		bigint;
nr_seq_protocolo_w	bigint;
nr_seq_prot_med_w	integer;
nr_seq_proc_w		integer;
nr_seq_proc_interno_w	bigint;
qt_procedimento_w		double precision;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_agrupamento_proc_w	double precision;
nr_seq_proc_ww		bigint;
nr_seq_interna_w	bigint;

c01 CURSOR FOR
	SELECT	cd_protocolo,
		coalesce(nr_seq_protocolo,0)
	from	dispositivo_protocolo
	where	nr_sequencia = nr_seq_disp_prot_p;

c02 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_interna
	from	protocolo_medicacao
	where (nr_seq_interna = nr_seq_protocolo_w or nr_seq_protocolo_w = 0)
	and	cd_protocolo = cd_protocolo_w;

c03 CURSOR FOR
	SELECT	nr_seq_proc,
		nr_seq_proc_interno,
		qt_procedimento
	from	protocolo_medic_proc
	where	cd_protocolo = cd_protocolo_w
	and	nr_sequencia = nr_seq_prot_med_w;


BEGIN

open c01;
loop
fetch c01 into
	cd_protocolo_w,
	nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	open c02;
	loop
	fetch c02 into
		nr_seq_prot_med_w,
		nr_seq_interna_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		open c03;
		loop
		fetch c03 into
			nr_seq_proc_ww,
			nr_seq_proc_interno_w,
			qt_procedimento_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin

			select	coalesce(max(nr_sequencia),0) + 1,
				coalesce(max(nr_agrupamento),0) + 1
			into STRICT	nr_seq_proc_w,
				nr_agrupamento_proc_w
			from	prescr_procedimento
			where	nr_prescricao = nr_prescricao_p;

			select	cd_procedimento,
				ie_origem_proced
			into STRICT	cd_procedimento_w,
				ie_origem_proced_w
			from	proc_interno
			where	nr_sequencia = nr_seq_proc_interno_w;

			insert into prescr_procedimento(
				nr_prescricao,
				nr_sequencia,
				cd_procedimento,
				qt_procedimento,
				dt_atualizacao,
				nm_usuario,
				ie_origem_proced,
				ie_origem_inf,
				nr_seq_interno,
				cd_protocolo,
				nr_seq_protocolo,
				nr_seq_proc_interno,
				nr_agrupamento,
				nr_seq_proc_protocolo)
			Values (
				nr_prescricao_p,
				nr_seq_proc_w,
				cd_procedimento_w,
				qt_procedimento_w,
				clock_timestamp(),
				nm_usuario_p,
				ie_origem_proced_w,
				'1',
				nextval('prescr_procedimento_seq'),
				cd_protocolo_w,
				CASE WHEN nr_seq_prot_med_w=0 THEN null  ELSE nr_seq_prot_med_w END ,
				nr_seq_proc_interno_w,
				nr_agrupamento_proc_w,
				nr_seq_proc_ww);

			commit;

			CALL gerar_mat_prescr_dispositivo(nr_prescricao_p, cd_protocolo_w, nr_seq_prot_med_w, nr_seq_prot_med_w, nr_seq_proc_w,
				nr_seq_proc_w, nm_usuario_p);
			end;
		end loop;
		close c03;
		end;
	end loop;
	close c02;
	end;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_proc_prescr_dispositivo ( nr_seq_disp_prot_p bigint, nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;

