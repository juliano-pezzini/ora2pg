-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_solic_cancelar ( nr_seq_gestao_p bigint, cd_pessoa_fisica_p text, nr_tag_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_sequencia_w		bigint;	
var_Status_Cancelar_w	varchar(10);
nr_tag_w		bigint;
nr_seq_motivo_cance_w	bigint;
ie_permite_w		varchar(1) := 'N';
ie_status_cancelar_w	varchar(255);


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	gestao_vaga
	where	obter_se_contido_char(ie_status,ie_status_cancelar_w) = 'S'
	and	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	nr_sequencia    <> nr_seq_gestao_p;

BEGIN
var_Status_Cancelar_w := Obter_Param_Usuario(1002, 120, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, var_Status_Cancelar_w);
nr_seq_motivo_cance_w := Obter_Param_Usuario(1002, 121, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, nr_seq_motivo_cance_w);
ie_status_cancelar_w := Obter_Param_Usuario(1002, 123, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_status_cancelar_w);

if (nr_tag_p in (22,43568,378475))    	    and (coalesce(var_Status_Cancelar_w,'X') = 'L') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (4,11,43572,43584,378476,378481))  and (coalesce(var_Status_Cancelar_w,'X') = 'F') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (5,43573,378466))  	    and (coalesce(var_Status_Cancelar_w,'X') = 'A') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (6,43574,378465))  	    and (coalesce(var_Status_Cancelar_w,'X') = 'P') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (7,43575,378477))  	    and (coalesce(var_Status_Cancelar_w,'X') = 'N') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (8,9,43576,43582,378478,378468))   and (coalesce(var_Status_Cancelar_w,'X') = 'R') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (13,43577,378479)) 	    and (coalesce(var_Status_Cancelar_w,'X') = 'D') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (19,43578,378497))  and (coalesce(var_Status_Cancelar_w,'X') = 'C') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (32,43579,378496)) 	    and (coalesce(var_Status_Cancelar_w,'X') = 'H') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (33,72696,378499)) 	    and (coalesce(var_Status_Cancelar_w,'X') = 'E') then
	ie_permite_w	:= 'S';
elsif (nr_tag_p in (34,72697,378500)) 	    and (coalesce(var_Status_Cancelar_w,'X') = 'T') then
	ie_permite_w	:= 'S';
end if;	

ie_status_cancelar_w := upper(ie_status_cancelar_w);

if (ie_permite_w = 'S') and (coalesce(nr_seq_motivo_cance_w,0) > 0) and (ie_status_cancelar_w IS NOT NULL AND ie_status_cancelar_w::text <> '') then
	if (coalesce(var_Status_Cancelar_w,'X') <> 'X') then
		
		open C01;
		loop
		fetch C01 into	
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin				
			CALL cancelar_agenda_gestao_vaga(nr_sequencia_w,
							nr_seq_motivo_cance_w,
							wheb_mensagem_pck.get_texto(791717),
							nm_usuario_p,
							cd_estabelecimento_p);
			end;
		end loop;
		close C01;
	end if;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_solic_cancelar ( nr_seq_gestao_p bigint, cd_pessoa_fisica_p text, nr_tag_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

