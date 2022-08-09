-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_proc_pac_cir ( nr_sequencia_p bigint, nr_prescricao_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


qt_reg_w		bigint;
qt_proc_conta_w		bigint;
ds_retorno_w		varchar(255) := '';


BEGIN


select	count(*)
into STRICT	qt_proc_conta_w
from	procedimento_paciente
where	nr_sequencia_prescricao 	= nr_sequencia_p
and	nr_prescricao 			= nr_prescricao_p;

	if (qt_proc_conta_w > 0) then

		select	count(*)
		into STRICT	qt_reg_w
		from	procedimento_paciente
		where	nr_sequencia_prescricao 	= nr_sequencia_p
		and	nr_prescricao 			= nr_prescricao_p
		and	(cd_motivo_exc_conta IS NOT NULL AND cd_motivo_exc_conta::text <> '');

		if (qt_reg_w > 0) then

			update	procedimento_paciente
			set		nr_sequencia_prescricao  = NULL,
					nr_prescricao 			 = NULL
			where	nr_sequencia_prescricao = nr_sequencia_p
			and		nr_prescricao 			= nr_prescricao_p
			and		(cd_motivo_exc_conta IS NOT NULL AND cd_motivo_exc_conta::text <> '');

			/*update	prescr_proc_auditoria  --retirado pois o nr_prescricao nunca pode ser null
			set		nr_sequencia_prescricao = null,
					nr_prescricao 			= null
			where	nr_sequencia_prescricao = nr_sequencia_p
			and		nr_prescricao 			= nr_prescricao_p;*/
			commit;
		else
			ds_retorno_w := wheb_mensagem_pck.get_texto(298604,'');
		end if;

	end if;

ds_retorno_p := ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_proc_pac_cir ( nr_sequencia_p bigint, nr_prescricao_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
