-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_gerar_intervencao_padrao ( nr_sequencia_p bigint, list_nr_seq_proc_p text, nm_usuario_p text) AS $body$
DECLARE


		

nr_seq_diag_w		bigint;
nr_seq_proc_w		bigint;
nr_sequencia_w		bigint;
qt_existe_w		bigint;
nr_seq_result_w		bigint;
cd_intervalo_w		varchar(7);
ds_horario_padrao_w	varchar(2000);
nr_seq_probl_colab_w	bigint;
ds_observacao_padr_w	varchar(255);
ie_adep_w		varchar(1);
vl_prim_hor_w		varchar(15);
hr_prim_horario_w		timestamp;
nr_intervalo_w		real;
ds_horarios_w		varchar(2000);
dt_prescricao_w		timestamp;
qt_horas_validade_w	bigint;

ds_lista_w			varchar(2000) := '';
ds_lista_aux_w			varchar(2000) := '';
k				integer;
nr_seq_proc_ww			bigint;
cd_setor_atendimento_w		bigint;
ds_prim_horario_w		varchar(255);
ie_se_necessario_w		varchar(1);
ie_auxiliar_w       	varchar(10);
ie_encaminhar_w     	varchar(10);
ie_fazer_w         	varchar(10);
ie_orientar_w       	varchar(10);
ie_supervisionar_w   	varchar(10);
		
C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.cd_intervalo,
		a.ds_horario_padrao,
		a.ds_observacao_padr,
		a.ie_adep,
		a.ie_auxiliar,
		a.ie_encaminhar,
		a.ie_fazer,
		a.ie_orientar,
		a.ie_supervisionar
	from	pe_procedimento a
	where	a.nr_sequencia	= nr_seq_proc_ww
	and	Obter_se_intervencao_lib(a.nr_sequencia,Obter_Perfil_Ativo,cd_setor_Atendimento_w,nm_usuario_p,'I')	= 'S'
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	not exists (	SELECT	1
					from	pe_prescr_proc x
					where	x.nr_seq_prescr	= nr_sequencia_p
					and	x.nr_seq_proc	= a.nr_sequencia);

BEGIN

	

ds_lista_w := list_nr_seq_proc_p;

vl_prim_hor_w := obter_param_usuario(281, 325, obter_perfil_ativo, nm_usuario_p, 0, vl_prim_hor_w);

select	qt_horas_validade,
	cd_setor_atendimento
into STRICT	qt_horas_validade_w,
	cd_setor_atendimento_w
from	pe_prescricao
where	nr_sequencia	= nr_sequencia_p;

while (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') loop
	begin
	
	select	position(',' in ds_lista_w) 
	into STRICT	k
	;

	if (k > 1) and ((substr(ds_lista_w, 1, k -1) IS NOT NULL AND (substr(ds_lista_w, 1, k -1))::text <> '')) then
		ds_lista_aux_w			:= substr(ds_lista_w, 1, k-1);
		nr_seq_proc_ww			:= replace(ds_lista_aux_w, ',','');
		ds_lista_w			:= substr(ds_lista_w, k + 1, 2000);
	elsif (ds_lista_w IS NOT NULL AND ds_lista_w::text <> '') then
		nr_seq_proc_ww			:= replace(ds_lista_w,',','');
		ds_lista_w			:= '';
	end if;

	open C01;
	loop
	fetch C01 into	
		nr_seq_proc_w,
		cd_intervalo_w,
		ds_horario_padrao_w,
		ds_observacao_padr_w,
		ie_adep_w,
		ie_auxiliar_w    ,
		ie_encaminhar_w  ,     
		ie_fazer_w       ,     
		ie_orientar_w    ,     
		ie_supervisionar_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		CALL Gerar_Intervencao_Padrao(nr_sequencia_p,nr_seq_proc_w,nm_usuario_p);
		
		end;
	end loop;
	close C01;

	end;
end loop;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_gerar_intervencao_padrao ( nr_sequencia_p bigint, list_nr_seq_proc_p text, nm_usuario_p text) FROM PUBLIC;
