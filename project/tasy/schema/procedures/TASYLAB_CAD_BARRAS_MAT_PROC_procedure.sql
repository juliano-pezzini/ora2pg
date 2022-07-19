-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasylab_cad_barras_mat_proc ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_prescr_proc_mat_p bigint, ie_status_p text, nr_seq_externo_p bigint, cd_erro_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


nr_sequencia_w			prescr_proc_mat_item.nr_sequencia%type;
ie_existe_w			varchar(1);
ie_existe_procedimento_w	varchar(1);


BEGIN

cd_erro_p	:= 0;

CALL tasy_atualizar_dados_sessao(nr_seq_externo_p);

if (coalesce(nr_seq_prescr_p::text, '') = '') then
	cd_erro_p	:= 13;
elsif (coalesce(ie_status_p::text, '') = '') then
	cd_erro_p	:= 22;
end if;

if (cd_erro_p = 0) then

	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_existe_w
	from	prescr_proc_mat_item a
	where	a.nr_seq_prescr_proc_mat = nr_seq_prescr_proc_mat_p
	and		a.nr_prescricao = nr_prescricao_p
	and		a.nr_seq_prescr = nr_seq_prescr_p;

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_existe_procedimento_w
	from	prescr_procedimento a
	where	a.nr_prescricao = nr_prescricao_p
	and	a.nr_sequencia = nr_seq_prescr_p;

	if (ie_existe_w = 'N') and (ie_existe_procedimento_w = 'S') then
		begin
		select	nextval('prescr_proc_mat_item_seq')
		into STRICT	nr_sequencia_w
		;

		insert into prescr_proc_mat_item(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										nr_prescricao,
										nr_seq_prescr,
										nr_seq_prescr_proc_mat,
										ie_status)
								values (
										nr_sequencia_w,
										clock_timestamp(),
										'TasyLab-procIte',
										nr_prescricao_p,
										nr_seq_prescr_p,
										nr_seq_prescr_proc_mat_p,
										ie_status_p);

		--OS727249 - Ivan
		--commit;
		exception
		when others then
			cd_erro_p	:= 1;
			ds_erro_p	:= substr('Erro ao registrar o item do material do procedimento '||sqlerrm,1,2000);
		end;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasylab_cad_barras_mat_proc ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_prescr_proc_mat_p bigint, ie_status_p text, nr_seq_externo_p bigint, cd_erro_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;

