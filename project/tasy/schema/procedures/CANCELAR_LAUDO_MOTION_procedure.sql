-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_laudo_motion (nr_prescricao_p bigint, nr_sequencia_p bigint, nr_acesso_dicom_p text, nr_seq_interno_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


nr_prescricao_w       prescr_procedimento.nr_prescricao%type;
nr_sequencia_w        prescr_procedimento.nr_sequencia%type;
nr_sequencia_laudo_w  laudo_paciente.nr_sequencia%type;


BEGIN

begin
  select nr_prescricao, nr_sequencia
  into STRICT nr_prescricao_w, nr_sequencia_w
  from (SELECT nr_prescricao, nr_sequencia
        from prescr_procedimento
        where ((nr_prescricao = nr_prescricao_p and nr_sequencia = nr_sequencia_p)
        or (nr_acesso_dicom = nr_acesso_dicom_p)
        or (nr_seq_interno = nr_seq_interno_p))
        order by nr_seq_interno desc) alias4 LIMIT 1;
exception when others then
  nr_prescricao_w := null; nr_sequencia_w := null;
end;

if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '' AND nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
  select  max(nr_sequencia)
	into STRICT	nr_sequencia_laudo_w
	from 	laudo_paciente
	where   nr_prescricao = nr_prescricao_w
	and		nr_seq_prescricao = nr_sequencia_w;

	if (coalesce(nr_sequencia_laudo_w, 0) <> 0) then
		CALL cancelar_laudo_paciente(nr_sequencia_laudo_w, 'C', expressao_pck.obter_desc_expressao(292128), '');

    update laudo_paciente
    set nm_usuario_aprovacao  = NULL, dt_liberacao  = NULL, nm_usuario_seg_aprov  = NULL
    where nr_sequencia = nr_sequencia_laudo_w;
	end if;

  commit;
else
  ds_erro_p := expressao_pck.obter_desc_expressao(501736);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_laudo_motion (nr_prescricao_p bigint, nr_sequencia_p bigint, nr_acesso_dicom_p text, nr_seq_interno_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

