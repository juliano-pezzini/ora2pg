-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_gerar_setor_rotina (cd_estabelecimento_p bigint, cd_funcao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, cd_setor_prescricao_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

					
ie_gerar_setor_w		varchar(1) := 'S';
ie_somente_exclusivo_w	varchar(1) := 'N';
cd_setor_exclusivo_w	integer;
qt_setor_exclusivo_w	bigint;
nr_seq_agrupamento_w	bigint;
					

BEGIN

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	if (cd_funcao_p = 916) then
		ie_somente_exclusivo_w := Obter_Param_Usuario(916, 200, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_somente_exclusivo_w);		
	elsif (cd_funcao_p = 924) then
		ie_somente_exclusivo_w := Obter_Param_Usuario(924, 260, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_somente_exclusivo_w);		
	else
		ie_gerar_setor_w := 'S';
	end if;
	
	if (ie_somente_exclusivo_w <> 'N') and (ie_somente_exclusivo_w <> 'E') then
		ie_somente_exclusivo_w := 'S';
	end if;
	
	if (ie_somente_exclusivo_w = 'S') then
		begin
		
		select	coalesce(max(cd_setor_exclusivo),0)
		into STRICT	cd_setor_exclusivo_w
		from	procedimento
		where	cd_procedimento		= cd_procedimento_p
		and	ie_origem_proced	= ie_origem_proced_p;
		
		if (cd_setor_exclusivo_w = 0) then
		
			if (coalesce(nr_seq_proc_interno_p,0) > 0) then
				begin
				
				select	coalesce(max(nr_seq_agrupamento),0)
				into STRICT	nr_seq_agrupamento_w
				from	setor_atendimento
				where	cd_setor_atendimento = cd_setor_prescricao_p;

				select	count(*)
				into STRICT	qt_setor_exclusivo_w
				from	proc_interno_setor
				where	nr_seq_proc_interno = nr_seq_proc_interno_p
				and		coalesce(cd_setor_origem,coalesce(cd_setor_prescricao_p,0)) = coalesce(cd_setor_prescricao_p,0)
				and		coalesce(ie_banco_sangue_rep,'N') = 'N'
				and		coalesce(cd_perfil,coalesce(obter_perfil_ativo,0)) = coalesce(obter_perfil_ativo,0)
				and		coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
				and		coalesce(nr_seq_agrupamento, coalesce(nr_seq_agrupamento_w,0)) = coalesce(nr_seq_agrupamento_w,0);
				
				if (qt_setor_exclusivo_w = 0) then		
					select	count(*)
					into STRICT	qt_setor_exclusivo_w
					from	exame_lab_setor
					where	nr_seq_exame = nr_seq_exame_p
					and		coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)					
					and		coalesce(cd_setor_origem,coalesce(cd_setor_prescricao_p,0))	= coalesce(cd_setor_prescricao_p,0);				
				end if;				
				
				if (qt_setor_exclusivo_w > 1) then
					ie_gerar_setor_w := 'N';
				elsif (qt_setor_exclusivo_w = 0) then
					begin

					select	count(*)
					into STRICT	qt_setor_exclusivo_w
					from	procedimento_setor_atend
					where	cd_procedimento		= cd_procedimento_p
					and	ie_origem_proced	= ie_origem_proced_p
					and	coalesce(cd_setor_origem,cd_setor_prescricao_p)	= cd_setor_prescricao_p
					and	cd_estabelecimento	= cd_estabelecimento_p
					and	coalesce(ie_banco_sangue_rep,'N')	= 'N';

					if (qt_setor_exclusivo_w > 1) then
						ie_gerar_setor_w := 'N';
					else
						ie_gerar_setor_w := 'S';
					end if;	
					end;
				else
					ie_gerar_setor_w := 'S';
				end if;		
		
				end;
				
			elsif (coalesce(nr_seq_exame_p,0) > 0) then

				select	count(*)
				into STRICT	qt_setor_exclusivo_w
				from	exame_lab_setor
				where	nr_seq_exame 		= nr_seq_exame_p
				and	coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p
				and	coalesce(cd_setor_origem,cd_setor_prescricao_p)	= cd_setor_prescricao_p;		
				
				if (qt_setor_exclusivo_w > 1) then
					ie_gerar_setor_w := 'N';
				elsif (qt_setor_exclusivo_w = 0) then
					begin

					select	count(*)
					into STRICT	qt_setor_exclusivo_w
					from	procedimento_setor_atend
					where	cd_procedimento		= cd_procedimento_p
					and	ie_origem_proced	= ie_origem_proced_p
					and	coalesce(cd_setor_origem,cd_setor_prescricao_p)	= cd_setor_prescricao_p
					and	cd_estabelecimento	= cd_estabelecimento_p
					and	coalesce(ie_banco_sangue_rep,'N')	= 'N';

					if (qt_setor_exclusivo_w > 1) then
						ie_gerar_setor_w := 'N';
					else
						ie_gerar_setor_w := 'S';
					end if;	
					end;
				else
					ie_gerar_setor_w := 'S';
				end if;									
			else
				select	count(*)
				into STRICT	qt_setor_exclusivo_w
				from	procedimento_setor_atend
				where	cd_procedimento		= cd_procedimento_p
				and	ie_origem_proced	= ie_origem_proced_p
				and	coalesce(cd_setor_origem,cd_setor_prescricao_p)	= cd_setor_prescricao_p
				and	cd_estabelecimento	= cd_estabelecimento_p
				and	coalesce(ie_banco_sangue_rep,'N')	= 'N';
				
				if (qt_setor_exclusivo_w > 1) then
					ie_gerar_setor_w := 'N';
				else
					ie_gerar_setor_w := 'S';
				end if;	
			end if;
		else
			ie_gerar_setor_w := 'S';
		end if;
		end;
	else
		ie_gerar_setor_w := 'S';
	end if;
	end;
end if;

return ie_gerar_setor_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_gerar_setor_rotina (cd_estabelecimento_p bigint, cd_funcao_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_proc_interno_p bigint, nr_seq_exame_p bigint, cd_setor_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
