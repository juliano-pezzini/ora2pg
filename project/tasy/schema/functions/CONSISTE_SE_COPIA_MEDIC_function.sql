-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_se_copia_medic ( nr_prescricao_p bigint, nr_seq_medic_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_copia_direta_w		varchar(15);
ie_forma_copia_medic_w		varchar(15);
ie_retorno_w			varchar(1)	:= 'N';
qt_registro_w			bigint;


BEGIN

/* Leitura dos parâmetros envolvidos na cópia */

ie_copia_direta_w := Obter_Param_Usuario(924, 173, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_copia_direta_w);
if (ie_copia_direta_w <> 'N') then /* Cópia direta sem seleção de itens */
	ie_retorno_w	:= 'S';
else /* Cópia com seleção de itens */
	begin
	/* Leitura da forma de cópia */

	ie_forma_copia_medic_w := Obter_Param_Usuario(924, 198, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_forma_copia_medic_w);
	if (ie_forma_copia_medic_w = 'T') then /* Copia todos */
		ie_retorno_w			:= 'S';
	elsif (ie_forma_copia_medic_w = 'S') then /* Copia todos com os substituídos */
		select	coalesce(max('S'),'N')
		into STRICT	ie_retorno_w
		from	prescr_material
		where	nr_prescricao		= nr_prescricao_p
		and	nr_sequencia		= nr_seq_medic_p
		and	ie_agrupador		= 1
		and	coalesce(nr_sequencia_solucao::text, '') = ''
		and	coalesce(nr_sequencia_proc::text, '') = ''
		and	coalesce(nr_sequencia_dieta::text, '') = ''
		and	coalesce(nr_sequencia_diluicao::text, '') = ''
		and	coalesce(nr_seq_substituto::text, '') = '';
	elsif (ie_forma_copia_medic_w = 'B') then /* Copia todos com os substitutos */
		select	count(*)
		into STRICT	qt_registro_w
		from	prescr_material
		where	nr_prescricao		= nr_prescricao_p
		and	nr_sequencia		= nr_seq_medic_p
		and	ie_agrupador		= 1
		and	coalesce(nr_sequencia_solucao::text, '') = ''
		and	coalesce(nr_sequencia_proc::text, '') = ''
		and	coalesce(nr_sequencia_dieta::text, '') = ''
		and	coalesce(nr_sequencia_diluicao::text, '') = ''
		and	(nr_seq_substituto IS NOT NULL AND nr_seq_substituto::text <> '');

		if (qt_registro_w > 0) then
			ie_retorno_w		:= 'S';
		else
			select	count(*)
			into STRICT	qt_registro_w
			from	prescr_material
			where	nr_prescricao		= nr_prescricao_p
			and	nr_seq_substituto	= nr_seq_medic_p
			and	ie_agrupador		= 1
			and	coalesce(nr_sequencia_solucao::text, '') = ''
			and	coalesce(nr_sequencia_proc::text, '') = ''
			and	coalesce(nr_sequencia_dieta::text, '') = ''
			and	coalesce(nr_sequencia_diluicao::text, '') = ''
			and	(nr_seq_substituto IS NOT NULL AND nr_seq_substituto::text <> '');

			if (qt_registro_w = 0) then
				ie_retorno_w		:= 'S';
			end if;
		end if;
	end if;
	end;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_se_copia_medic ( nr_prescricao_p bigint, nr_seq_medic_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

