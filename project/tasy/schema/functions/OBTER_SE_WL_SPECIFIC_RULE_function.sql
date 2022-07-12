-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_wl_specific_rule ( nr_seq_worklist_p wl_worklist.nr_sequencia%type, nr_seq_wl_perfil_p wl_perfil.nr_sequencia%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type) RETURNS varchar AS $body$
DECLARE


nr_seq_wl_item_w	wl_perfil.nr_sequencia%type;
cd_categoria_w		wl_item.cd_categoria%type;
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;

nr_seq_item_cpoe_w	wl_worklist.nr_seq_item_cpoe%type;
ie_tipo_item_cpoe_w	wl_worklist.ie_tipo_item_cpoe%type;

ie_return_w	varchar(1) := 'N';


BEGIN

if (nr_seq_worklist_p IS NOT NULL AND nr_seq_worklist_p::text <> '' AND nr_seq_wl_perfil_p IS NOT NULL AND nr_seq_wl_perfil_p::text <> '') then

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_wl_item_w
	from 	wl_item a,
		wl_regra_worklist b,
		wl_regra_item c,
		wl_perfil d
	where	d.nr_sequencia = nr_seq_wl_perfil_p
	and	a.nr_sequencia = b.nr_seq_item
	and	b.nr_sequencia = c.nr_seq_regra
	and	c.nr_sequencia = d.nr_seq_regra_item
	and (coalesce(d.cd_perfil::text, '') = '' or obter_se_perfil_usuario(d.cd_perfil, nm_usuario_p) = 'S');

	if (nr_seq_wl_item_w > 0) then
	
		select	nr_seq_item_cpoe,
			ie_tipo_item_cpoe,
			nr_atendimento
		into STRICT	nr_seq_item_cpoe_w,
			ie_tipo_item_cpoe_w,
			nr_atendimento_w
		from	wl_worklist
		where	nr_sequencia = nr_seq_worklist_p;
	
		cd_categoria_w := obter_categoria_worklist(nr_seq_wl_item_w);
		
		if ((nr_seq_item_cpoe_w IS NOT NULL AND nr_seq_item_cpoe_w::text <> '') and (ie_tipo_item_cpoe_w IS NOT NULL AND ie_tipo_item_cpoe_w::text <> '') and (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '')) then
			if (cd_categoria_w = 'RC' and wl_is_needs_acknowledgement(nr_atendimento_w, nr_seq_item_cpoe_w, ie_tipo_item_cpoe_w, nm_usuario_p, cd_perfil_p)) then
				ie_return_w := 'S';

			elsif (cd_categoria_w in ('C', 'LFP') and wl_is_function_sector_released(2314, nr_atendimento_w, nm_usuario_p) and cpoe_verifica_regra_aprovacao(cd_perfil_p, nm_usuario_p, 'CI') = 'S') then
				ie_return_w := 'S';

			elsif (cd_categoria_w = 'NS' and wl_is_function_sector_released(2314, nr_atendimento_w, nm_usuario_p)) then
				ie_return_w := 'S';
				
			elsif (cd_categoria_w = 'D' and wl_is_function_sector_released(2314, nr_atendimento_w, nm_usuario_p)) then
				ie_return_w := 'S';
				
			elsif (cd_categoria_w = 'VN' and wl_is_function_sector_released(2314, nr_atendimento_w, nm_usuario_p)) then
				ie_return_w := 'S';
			end if;
		end if;
		
	end if;
end if;

return ie_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_wl_specific_rule ( nr_seq_worklist_p wl_worklist.nr_sequencia%type, nr_seq_wl_perfil_p wl_perfil.nr_sequencia%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

