-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_peso_aval_nutri_md ( ie_origem_peso_p text, qt_circ_braco_p bigint, qt_altura_joelho_p bigint, ie_sexo_p text, ie_raca_negra_p text, qt_idade_p bigint, qt_circ_panturrilha_p bigint, qt_prega_cut_subesc_p bigint, qt_circ_abdomem_p bigint) RETURNS bigint AS $body$
DECLARE

    qt_peso_atual_w     double precision;

BEGIN

    if (ie_origem_peso_p = 'C' ) and (qt_prega_cut_subesc_p IS NOT NULL AND qt_prega_cut_subesc_p::text <> '') and (qt_circ_panturrilha_p IS NOT NULL AND qt_circ_panturrilha_p::text <> '') and (qt_circ_braco_p IS NOT NULL AND qt_circ_braco_p::text <> '') and (qt_altura_joelho_p IS NOT NULL AND qt_altura_joelho_p::text <> '') then
        begin
            if ( ie_sexo_p = 'M' ) then
                qt_peso_atual_w := ( coalesce(( 0.98 * qt_circ_panturrilha_p ),0) + coalesce(( 1.16 * qt_altura_joelho_p ),0) + coalesce(( 1.73 * qt_circ_braco_p ),0) + coalesce(( 0.37 * qt_prega_cut_subesc_p ),0) - 81.69 );
            else
                qt_peso_atual_w := ( coalesce(( 1.27 * qt_circ_panturrilha_p ),0) + coalesce(( 0.87 * qt_altura_joelho_p ),0) + coalesce(( 0.98 * qt_circ_braco_p ),0) + coalesce(( 0.4 * qt_prega_cut_subesc_p ),0) - 62.35 );
            end if;
        end;
    end if;

    if ( ie_origem_peso_p = 'R' ) and (qt_circ_panturrilha_p IS NOT NULL AND qt_circ_panturrilha_p::text <> '') and (qt_circ_abdomem_p IS NOT NULL AND qt_circ_abdomem_p::text <> '') and (qt_circ_braco_p IS NOT NULL AND qt_circ_braco_p::text <> '') then
        begin
            if ( ie_sexo_p = 'M' ) THEN
                qt_peso_atual_w := ( coalesce(( 0.5759 * qt_circ_braco_p ),0) + coalesce(( 0.5263 * qt_circ_abdomem_p ),0) + coalesce(( 1.2452 * qt_circ_panturrilha_p ),0) - ( 4.8689 * 1 ) - 32.9241 );
            else
                qt_peso_atual_w := ( coalesce(( 0.5759 * qt_circ_braco_p ),0) + coalesce(( 0.5263 * qt_circ_abdomem_p ),0) + coalesce(( 1.2452 * qt_circ_panturrilha_p ),0) - ( 4.8689 * 2 ) - 32.9241 );
            end if;
        end;
    end if;
	
	if ( ie_origem_peso_p = 'J' ) and (qt_circ_braco_p IS NOT NULL AND qt_circ_braco_p::text <> '') and (qt_altura_joelho_p IS NOT NULL AND qt_altura_joelho_p::text <> '') then
        begin
            if ( ie_sexo_p = 'M' ) then
                if ( ie_raca_negra_p = 'N') then
                    if ( qt_idade_p between 19 and 59 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 1.19 ),0) + coalesce(( qt_circ_braco_p * 3.14 ),0) - ( 83.72 ) );
                    elsif ( qt_idade_p between 60 and 80 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 1.10 ),0) + coalesce(( qt_circ_braco_p * 3.07 ),0) - ( 75.81 ) );
                    end if;
				else
                    if ( qt_idade_p between 19 and 59 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 1.09 ),0) + coalesce(( qt_circ_braco_p * 3.14 ),0) - ( 83.72 ) );

                    elsif ( qt_idade_p between 60 and 80 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 0.44 ),0) + coalesce(( qt_circ_braco_p * 2.86 ),0) - ( 39.21 ) );
                    end if;
                end if;

            elsif ( ie_sexo_p = 'F' ) then
                if ( ie_raca_negra_p = 'N' ) then
                    if ( qt_idade_p between 19 and 59 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 1.01 ),0) + coalesce(( qt_circ_braco_p * 2.81 ),0) - ( 66.04 ) );

                    elsif ( qt_idade_p between 60 and 80 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 1.09 ),0) + coalesce(( qt_circ_braco_p * 2.68 ),0) - ( 65.51 ) );
                    end if;

                else
                    if ( qt_idade_p between 19 and 59 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 1.24 ),0) + coalesce(( qt_circ_braco_p * 2.97 ),0) - ( 82.48 ) );

                    elsif ( qt_idade_p between 60 and 80 ) then
                        qt_peso_atual_w := ( coalesce(( qt_altura_joelho_p * 1.50 ),0) + coalesce(( qt_circ_braco_p * 2.58 ),0) - ( 84.22 ) );
                    end if;
                end if;
            end if;

        end;

    end if;

    return qt_peso_atual_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_peso_aval_nutri_md ( ie_origem_peso_p text, qt_circ_braco_p bigint, qt_altura_joelho_p bigint, ie_sexo_p text, ie_raca_negra_p text, qt_idade_p bigint, qt_circ_panturrilha_p bigint, qt_prega_cut_subesc_p bigint, qt_circ_abdomem_p bigint) FROM PUBLIC;

