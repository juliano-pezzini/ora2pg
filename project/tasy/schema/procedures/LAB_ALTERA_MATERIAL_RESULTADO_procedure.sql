-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_altera_material_resultado ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_material_exame_p text, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


cd_material_exame_w		varchar(20);
nr_seq_material_w		bigint;
nr_seq_resultado_w		bigint;
nr_seq_exame_w			bigint;
ds_erro_w			varchar(4000);


BEGIN

select 	Max(cd_material_exame),
		MAX(nr_seq_exame)
into STRICT 	cd_material_exame_w,
		nr_seq_exame_w
from 	prescr_procedimento
where 	nr_prescricao = nr_prescricao_p
and		nr_sequencia = nr_sequencia_p;

ds_erro_w := 'OK';
if (cd_material_exame_w <> cd_material_exame_p) then
		begin
		select  MAX(nr_sequencia)
		into STRICT	nr_seq_material_w
		from	material_exame_lab
		where 	trim(both coalesce(cd_material_integracao,cd_material_exame)) = trim(both cd_material_exame_p);

		if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
			select MAX(nr_seq_resultado)
			into STRICT 	nr_seq_resultado_w
			from	exame_lab_resultado
			where 	nr_prescricao = nr_prescricao_p;

			if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') then
				update 	exame_lab_result_item
				set		nr_seq_material_integr = nr_seq_material_w,
						nm_usuario	=	nm_usuario_p,
						dt_atualizacao = clock_timestamp()
				WHERE   nr_seq_resultado = nr_seq_resultado_w
				and		nr_seq_prescr = nr_sequencia_p
				and		(nr_seq_material IS NOT NULL AND nr_seq_material::text <> '');
			else
				update  result_laboratorio
				set  	nr_seq_material_integr = nr_seq_material_w,
						dt_atualizacao = clock_timestamp(),
						nm_usuario = nm_usuario_p
				where  	nr_prescricao = nr_prescricao_p
				and  	nr_seq_prescricao = nr_sequencia_p;
			end if;

		end if;
		exception
				when others then
				ds_erro_w := wheb_mensagem_pck.get_texto(280173,'NR_SEQ_EXAME='|| nr_seq_exame_w||';NR_PRESCRICAO='||nr_prescricao_p);
				commit;

		end;
end if;
ds_erro_p := ds_erro_w;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_altera_material_resultado ( nr_prescricao_p bigint, nr_sequencia_p bigint, cd_material_exame_p text, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;

