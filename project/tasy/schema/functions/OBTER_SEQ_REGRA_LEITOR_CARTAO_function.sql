-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_regra_leitor_cartao ( nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_computador_p text default null) RETURNS bigint AS $body$
DECLARE


-- Atributos
nr_sequencia_regra_w    bigint := 0;
qt_regras_w             bigint := 0;
ie_type_integration_w   varchar(10);

-- Cursores
c_regras_legado CURSOR FOR
SELECT  a.nr_sequencia
from    regra_leitor_cartao_pac a
where   coalesce(a.nm_computador,coalesce(nm_computador_p,'XPTO')) = coalesce(nm_computador_p,'XPTO')
and     coalesce(a.nm_usuario_regra,coalesce(nm_usuario_p,'XPTO')) = coalesce(nm_usuario_p,'XPTO')
and     coalesce(a.cd_perfil,coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
and     coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
order by
        coalesce(a.cd_estabelecimento,0),
        coalesce(a.cd_perfil,0),
        a.nm_usuario_regra nulls first,
        a.nm_computador nulls first;

c_regras_telematik CURSOR FOR
SELECT  a.nr_sequencia
from    estacao_trabalho_lib a
where   coalesce(a.nm_computador,coalesce(nm_computador_p,'XPTO')) = coalesce(nm_computador_p,'XPTO')
and     coalesce(a.nm_usuario_lib,coalesce(nm_usuario_p,'XPTO')) = coalesce(nm_usuario_p,'XPTO')
and     coalesce(a.cd_perfil,coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
and     coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
order by
        coalesce(a.cd_estabelecimento,0),
        coalesce(a.cd_perfil,0),
        a.nm_usuario_lib nulls first,
        a.nm_computador nulls first;


-- Funcao
BEGIN
    
    ie_type_integration_w := obter_param_usuario(1751, 8, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_type_integration_w);

    if (ie_type_integration_w = 'T')then
        for linha_cursor in c_regras_telematik loop
            if (nr_sequencia_regra_w = 0)then
                nr_sequencia_regra_w := linha_cursor.nr_sequencia;
            end if;
        end loop;
    elsif (ie_type_integration_w = 'E')then
        for linha_cursor_legado in c_regras_legado loop
            if (nr_sequencia_regra_w = 0)then
                nr_sequencia_regra_w := linha_cursor_legado.nr_sequencia;
            end if;
        end loop;
    elsif (ie_type_integration_w = 'D')then
		for linha_cursor in c_regras_telematik loop
            if (nr_sequencia_regra_w = 0)then
                nr_sequencia_regra_w := linha_cursor.nr_sequencia;
            end if;
        end loop;
        if (nr_sequencia_regra_w = 0) then
			for linha_cursor_legado in c_regras_legado loop
				if (nr_sequencia_regra_w = 0)then
					nr_sequencia_regra_w := linha_cursor_legado.nr_sequencia;
				end if;
			end loop;
		end if;
    end if;

return nr_sequencia_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_regra_leitor_cartao ( nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_computador_p text default null) FROM PUBLIC;

