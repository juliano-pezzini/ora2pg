-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lab_int_mat_ind_matrix (nr_prescricao_p bigint, cd_setor_atendimento_p bigint, ie_opcao_p text, ie_separador_p text, ie_status_envio_p bigint, ds_sigla_p text, nr_seq_prescr_proc_mat_p text, nr_seq_lote_externo_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_opcao_w			varchar(255);
ie_status_atend_w			varchar(2);
cd_procedimento_w		bigint;
nr_seq_exame_w			bigint;
cd_exame_w			varchar(20);
cd_exame_integracao_w		varchar(20);
resultado_w	 		varchar(1000);
qt_linha_w			smallint := 0;
ds_material_especial_w		varchar(255);
nr_sequencia_w			bigint;
ds_aux_w			varchar(100);
nr_seq_amostra_w			varchar(2);
nm_exame_w			varchar(80);
ie_padrao_amostra_w		varchar(5);
nr_amostra_w			integer;
cd_exame_filho_w			varchar(100);
cd_material_exame_w		varchar(20);

c01 CURSOR FOR
	SELECT	a.cd_procedimento,
		b.nr_seq_exame,
		b.cd_exame,
		coalesce(Obter_Equipamento_Mat_Exame(a.nr_seq_exame,null,f.nr_sequencia,ds_sigla_p),coalesce(b.cd_exame_integracao, b.cd_exame)),
		max(a.nr_sequencia),
		b.nm_exame,
		d.nr_amostra,
		f.cd_material_exame
	from	exame_laboratorio b,
		prescr_procedimento a,
		prescr_proc_material d,
		prescr_proc_mat_item e,
		material_exame_lab f,
		exame_lab_resultado k,
		exame_lab_result_item y
	where a.nr_seq_exame		= b.nr_seq_exame
	and	k.nr_seq_resultado = y.nr_seq_resultado
	and	k.nr_prescricao = a.nr_prescricao
	and	y.nr_seq_prescr = a.nr_sequencia
	and	f.nr_sequencia = y.nr_seq_material
	  and e.NR_SEQ_PRESCR_PROC_MAT 	= d.nr_sequencia
	  and e.nr_prescricao		= a.nr_prescricao
	  and e.nr_seq_prescr		= a.nr_sequencia
	  --and a.cd_material_exame   = f.cd_material_exame
	  and a.nr_prescricao		= nr_prescricao_p
	  and coalesce(e.dt_integracao::text, '') = ''
	  and a.ie_suspenso <> 'S'
	  and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),b.cd_exame_integracao) is not null
	  and coalesce(a.cd_setor_atendimento,0)	= coalesce(coalesce(cd_setor_atendimento_p, a.cd_setor_atendimento),0)
	  and e.ie_status		= coalesce(ie_status_atend_w, a.ie_status_atend)
	  and (a.nr_seq_lote_externo	= coalesce(nr_seq_lote_externo_p, a.nr_seq_lote_externo) or (coalesce(nr_seq_lote_externo::text, '') = ''))
	  and e.nr_seq_prescr_proc_mat	= nr_seq_prescr_proc_mat_p
	group by 	a.cd_procedimento,
			b.nr_seq_exame,
			b.cd_exame,
			coalesce(Obter_Equipamento_Mat_Exame(a.nr_seq_exame,null,f.nr_sequencia,ds_sigla_p),coalesce(b.cd_exame_integracao, b.cd_exame)),
			b.nm_exame,
			d.nr_amostra,
			f.cd_material_exame
	order by 5;


BEGIN

/* opções
	cp	- código procedimento
	ex	- exame
	ce	- código exame
	ci	- código integração
	ci3	- código integração com 3 dígitos
	ci8	- código integração com 8 dígitos
	nme3	- nome do exame com 3 digitos
*/
resultado_w	:= '';
ie_opcao_w	:= ie_opcao_p;

select coalesce(max(ie_padrao_amostra),'PM')
into STRICT	ie_padrao_amostra_w
from 	lab_parametro
where 	cd_estabelecimento = cd_estabelecimento_p;

ie_status_atend_w := ie_status_envio_p;


open c01;
loop
fetch c01 into	cd_procedimento_w,
			nr_seq_exame_w,
			cd_exame_w,
			cd_exame_integracao_w,
			nr_sequencia_w,
			nm_exame_w,
			nr_amostra_w,
			cd_material_exame_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (ie_opcao_w = 'CP') then
		resultado_w	:= resultado_w || cd_procedimento_w || ie_separador_p;
	elsif (ie_opcao_w = 'EX') then
		resultado_w	:= resultado_w || nr_seq_exame_w || ie_separador_p;
	elsif (ie_opcao_w = 'CE') then
		resultado_w	:= resultado_w || cd_exame_w || ie_separador_p;
	elsif (ie_opcao_w = 'CI') then
		resultado_w	:= resultado_w || cd_exame_integracao_w || ie_separador_p;
	elsif (ie_opcao_w = 'CI3') then
		resultado_w	:= resultado_w || substr(cd_exame_integracao_w || '   ',1,3) || ie_separador_p;
	elsif (ie_opcao_w = 'CI8') then

		select 	max(cd_exame_integracao)
		into STRICT	cd_exame_filho_w
		from	exame_laboratorio
		where	nr_seq_superior = nr_seq_exame_w
		and	NR_ORDEM_AMOSTRA = nr_amostra_w;

		if (cd_exame_filho_w IS NOT NULL AND cd_exame_filho_w::text <> '') then
			resultado_w	:= resultado_w || substr(cd_exame_filho_w || '        ',1,8) || ie_separador_p;
		elsif (nr_amostra_w > 1) then
			resultado_w	:= resultado_w || substr(cd_exame_integracao_w || '_' || nr_amostra_w || '        ',1,8) || ie_separador_p;
		else
			resultado_w	:= resultado_w || substr(cd_exame_integracao_w || '        ',1,8) || ie_separador_p;
		end if;
	elsif (ie_opcao_w = 'NME3') then
		resultado_w	:= resultado_w || substr(nm_exame_w || '   ',1,3) || ie_separador_p;
	end if;

	end;
end loop;

return trim(both resultado_w || ' ');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lab_int_mat_ind_matrix (nr_prescricao_p bigint, cd_setor_atendimento_p bigint, ie_opcao_p text, ie_separador_p text, ie_status_envio_p bigint, ds_sigla_p text, nr_seq_prescr_proc_mat_p text, nr_seq_lote_externo_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

