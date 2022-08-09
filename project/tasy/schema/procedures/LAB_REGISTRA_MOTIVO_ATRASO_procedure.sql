-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_registra_motivo_atraso ( nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_seq_motivo_atraso_p prescr_procedimento_compl.nr_seq_motivo_atraso%type, DS_RESTRICAO_P text, nm_usuario_p text) AS $body$
DECLARE

			
ds_script_w		varchar(4000);
ds_sep_bv_w		varchar(50);

BEGIN

ds_sep_bv_w	:= obter_separador_bv;

--cabeçalho
ds_script_w :='declare '||
'nr_seq_proc_compl_w	prescr_procedimento.nr_seq_proc_compl%type; '||
'cursor C01 is '||
'	select	nr_seq_proc_compl '||
'	from	prescr_procedimento c '||
'	where	c.nr_prescricao = '|| nr_prescricao_p ||' '||
ds_restricao_p||'; ';

--corpo
ds_script_w := ds_script_w ||
'begin ' ||
'open C01; '||
'loop '||
'fetch C01 into '||
'	  nr_seq_proc_compl_w; '||
'exit when C01%notfound; '||
'	begin '||
'		if (nr_seq_proc_compl_w is not null) then '||
'			update	prescr_procedimento_compl '||
'			set	nr_seq_motivo_atraso = '|| coalesce(to_char(nr_seq_motivo_atraso_p),'null') || ', ' ||
'				dt_atualizacao = sysdate, '||
'				nm_usuario = '||q'[']'||nm_usuario_p||q'[']'||
'			where	nr_sequencia = nr_seq_proc_compl_w '||
'			and	nr_seq_motivo_atraso is null; '||
'		end if; '||

'	end; '||
'end loop; '||
'close C01; ';
--rodapé
ds_script_w := ds_script_w ||
'commit;'||
'end;';

CALL Exec_sql_Dinamico('lab_registra_motivo_atraso', ds_script_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_registra_motivo_atraso ( nr_prescricao_p prescr_procedimento.nr_prescricao%type, nr_seq_motivo_atraso_p prescr_procedimento_compl.nr_seq_motivo_atraso%type, DS_RESTRICAO_P text, nm_usuario_p text) FROM PUBLIC;
