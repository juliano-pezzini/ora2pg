-- FUNCTION: expressao_pck.obter_desc_expressao(bigint, text)

-- DROP FUNCTION IF EXISTS expressao_pck.obter_desc_expressao(bigint, text);

CREATE OR REPLACE FUNCTION expressao_pck.obter_desc_expressao(
	cd_expressao_p bigint,
	ds_locale_p text)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
                   
                    declare
	chave_w	varchar(100);
	
	begin

 return expressao_pck.obter_dic_expressao_loc(cd_expressao_p,ds_locale_p);
/*
	if	(cd_expressao_p	is not null) then
		chave_w		:= ds_locale_p||'_'||cd_expressao_p;

		if 	(vetor_w.EXISTS(chave_w) 
             -- and 
			-- (vetor_w(chave_w).ds_expressao is not null)
            ) then
			return vetor_w(chave_w).ds_expressao;
		else
			vetor_w(chave_w).cd_expressao		:= cd_expressao_p;
			vetor_w(chave_w).ds_expressao		:= obter_dic_expressao_loc(cd_expressao_p,ds_locale_p);

			return vetor_w(chave_w).ds_expressao;
		end if;	

	end if;

        */
	
    end;
    
$BODY$;

ALTER FUNCTION expressao_pck.obter_desc_expressao(bigint, text)
    OWNER TO postgres;


-- FUNCTION: expressao_pck.obter_desc_expressao(bigint, bigint)

-- DROP FUNCTION IF EXISTS expressao_pck.obter_desc_expressao(bigint, bigint);

CREATE OR REPLACE FUNCTION expressao_pck.obter_desc_expressao(
	cd_expressao_p bigint,
	nr_seq_idioma_p bigint DEFAULT NULL::bigint)
    RETURNS character varying
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE SECURITY DEFINER PARALLEL UNSAFE
AS $BODY$
BEGIN

	return	expressao_pck.obter_desc_expressao(cd_expressao_p, expressao_pck.obter_locale_idioma(coalesce(coalesce(nr_seq_idioma_p::int,philips_param_pck.get_nr_seq_idioma()::int),1)::int));
	
	END;

$BODY$;

ALTER FUNCTION expressao_pck.obter_desc_expressao(bigint, bigint)
    OWNER TO postgres;

